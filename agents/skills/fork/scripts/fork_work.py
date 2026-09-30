"""Fork Codex into a top Herdr pane and restart once after a completed update."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
from uuid import UUID


STORE_SCRIPT = (
    Path(__file__).resolve().parents[2] / "ticket/scripts/work_store.py"
)


def command(*arguments: str, timeout: int = 30) -> str:
    """Run an explicit command without a shell and return its output."""
    result = subprocess.run(
        arguments, capture_output=True, text=True, timeout=timeout, check=True
    )
    return result.stdout


def herdr(*arguments: str, timeout: int = 30) -> dict:
    """Read the result of one Herdr command and reject reported errors."""
    response = json.loads(command("herdr", *arguments, timeout=timeout))
    if "error" in response:
        raise ValueError(str(response["error"]))
    return response["result"]


def require(condition: bool, message: str) -> None:
    """Stop setup when a required identity or ownership check fails."""
    if not condition:
        raise ValueError(message)


def session_id(agent: dict) -> str:
    """Require a Codex session ID supplied by live Herdr metadata."""
    session = agent.get("agent_session") or {}
    require(
        agent.get("agent") == "codex"
        and session.get("agent") == "codex"
        and session.get("kind") == "id",
        "Herdr has not identified this Codex conversation.",
    )
    return str(UUID(session["value"]))


def preflight(arguments: argparse.Namespace) -> dict:
    """Verify the caller, source conversation, base, and unused destination."""
    require(os.environ.get("HERDR_ENV") == "1", "Run this script inside Herdr.")
    pane_id = os.environ.get("HERDR_PANE_ID")
    workspace_id = os.environ.get("HERDR_WORKSPACE_ID")
    require(bool(pane_id and workspace_id), "Herdr caller IDs are missing.")
    agent = herdr("agent", "get", pane_id)["agent"]
    source_session = session_id(agent)
    expected_session = arguments.session or os.environ.get("CODEX_THREAD_ID")
    if expected_session:
        require(
            source_session == str(UUID(expected_session)),
            "The requested session does not match the caller's live conversation.",
        )
    checkout = Path(
        command("git", "-C", str(arguments.cwd), "rev-parse", "--show-toplevel")
        .strip()
    ).resolve()
    require(
        agent["pane_id"] == pane_id and agent["workspace_id"] == workspace_id,
        "The agent does not match the caller's pane and workspace.",
    )
    live_cwd = agent.get("foreground_cwd") or agent.get("cwd")
    require(
        bool(live_cwd) and Path(live_cwd).resolve() == checkout,
        "The caller's agent and Git checkout differ.",
    )
    workspace = herdr("workspace", "get", workspace_id)["workspace"]
    binding = workspace.get("worktree") or {}
    require(
        Path(binding.get("checkout_path", "")).resolve() == checkout,
        "The caller's workspace and Git checkout differ.",
    )
    store = json.loads(command(
        sys.executable, str(STORE_SCRIPT), "inspect", "--cwd", str(checkout),
        "--origin", binding["repo_root"],
    ))
    command(
        "git", "-C", str(checkout), "check-ref-format", "--branch", arguments.branch
    )
    base = command(
        "git", "-C", str(checkout), "rev-parse", "--verify", "--end-of-options",
        f"{arguments.base}^{{commit}}",
    ).strip()
    branch_exists = subprocess.run(
        ["git", "-C", str(checkout), "show-ref", "--verify", "--quiet",
         f"refs/heads/{arguments.branch}"], check=False,
    )
    require(branch_exists.returncode == 1, "The destination branch already exists.")
    destination = arguments.path.resolve()
    registered = command(
        "git", "-C", str(checkout), "worktree", "list", "--porcelain", "-z"
    )
    require(
        not destination.exists() and f"worktree {destination}\0" not in registered,
        "The destination path exists or is already a registered worktree.",
    )
    require(
        not any(destination.is_relative_to(path) for path in [
            checkout, Path(store["origin"]),
        ]),
        "Create the destination outside the source and origin checkouts.",
    )
    require(
        re.fullmatch(r"[a-z][a-z0-9_-]{0,31}", arguments.name) is not None,
        "Use an agent name with lowercase letters, digits, underscores, or hyphens.",
    )
    agents = herdr("agent", "list")["agents"]
    require(
        all(item.get("name") != arguments.name for item in agents),
        "The destination agent name is already in use.",
    )
    label = arguments.label or arguments.branch
    workspaces = herdr("workspace", "list")["workspaces"]
    require(
        all(item.get("label") != label for item in workspaces),
        "The destination workspace label is already in use.",
    )
    require(
        not arguments.state.exists(),
        "Setup state already exists. Inspect it before retrying.",
    )
    state_path = arguments.state.resolve()
    store_path = Path(store["store"])
    local_evidence = state_path.is_relative_to(store_path)
    temporary = any(
        state_path.is_relative_to(path)
        for path in [Path(tempfile.gettempdir()).resolve(), Path("/tmp").resolve()]
    )
    require(
        not state_path.is_relative_to(destination)
        and (local_evidence or temporary)
        and (local_evidence or not any(
            state_path.is_relative_to(path)
            for path in [checkout, Path(store["origin"])]
        )),
        "Keep setup state in canonical local evidence or a separate temporary folder.",
    )
    if local_evidence:
        require(
            state_path.parent.is_dir(), "Initialize the local evidence folder first."
        )
        command(
            "git", "-C", store["origin"], "check-ignore", "--quiet", "--no-index",
            "--", str(state_path.parent) + "/",
        )
    require(bool(arguments.handoff.read_text().strip()), "The handoff file is empty.")
    if arguments.planning_dir:
        planning = arguments.planning_dir.resolve()
        require(
            planning.is_dir() and planning.is_relative_to(Path(store["store"])),
            "Additional planning access must stay inside the canonical planning store.",
        )
    command("codex", "fork", "--help")
    return {
        "source_checkout": str(checkout), "source_session": source_session,
        "source_workspace": workspace_id, "origin": store["origin"],
        "planning_store": store["store"], "base": base,
        "destination": str(destination), "branch": arguments.branch,
        "label": label, "name": arguments.name, "status": "checked",
    }


def setup(arguments: argparse.Namespace, state: dict) -> None:
    """Create the destination, split below its root pane, and start the fork."""
    arguments.state.parent.mkdir(parents=True, exist_ok=True)
    with arguments.state.open("x") as stream:
        json.dump(state, stream, indent=2)

    def save() -> None:
        """Retain completed stages and the pending action for recovery."""
        arguments.state.write_text(json.dumps(state, indent=2) + "\n")

    def mutate(stage: str, *argv: str, timeout: int = 30) -> dict:
        """Record a pending action before making one Herdr mutation."""
        state["pending"] = stage
        save()
        result = herdr(*argv, timeout=timeout)
        state.setdefault("results", {})[stage] = result
        state["completed"] = stage
        state.pop("pending", None)
        save()
        return result

    try:
        created = mutate(
            "worktree_created", "worktree", "create", "--cwd", state["origin"],
            "--branch", state["branch"], "--base", state["base"],
            "--path", state["destination"], "--label", state["label"], "--no-focus",
        )
        workspace_id = created["workspace"]["workspace_id"]
        top = created["root_pane"]["pane_id"]
        state.update(workspace=workspace_id, top_pane=top)
        save()
        workspace = herdr("workspace", "get", workspace_id)["workspace"]
        binding = workspace.get("worktree") or {}
        require(
            binding.get("is_linked_worktree") is True
            and Path(binding["checkout_path"]).resolve() == Path(state["destination"])
            and Path(binding["repo_root"]).resolve() == Path(state["origin"]),
            "The created workspace does not match the destination repository.",
        )
        checkout = state["destination"]
        branch = command("git", "-C", checkout, "branch", "--show-current").strip()
        head = command("git", "-C", checkout, "rev-parse", "HEAD").strip()
        require(
            branch == state["branch"] and head == state["base"],
            "The created worktree does not match the assigned branch and base.",
        )
        split = mutate(
            "bottom_pane_created", "pane", "split", "--pane", top,
            "--direction", "down", "--cwd", checkout, "--no-focus",
        )
        bottom = split["pane"]["pane_id"]
        state["bottom_pane"] = bottom
        save()
        layout = herdr("pane", "layout", "--pane", top)["layout"]
        panes = {item["pane_id"]: item["rect"] for item in layout["panes"]}
        require(
            top != bottom and panes[top]["y"] < panes[bottom]["y"]
            and panes[top]["x"] == panes[bottom]["x"],
            "The destination panes do not place the agent above the shell.",
        )
        native = ["fork", state["source_session"], "-C", checkout]
        if arguments.model:
            native.extend(["--model", arguments.model])
        if arguments.planning_dir:
            native.extend(["--add-dir", str(arguments.planning_dir.resolve())])

        def start_fork(stage: str) -> str:
            """Start the exact fork command and verify its destination identity."""
            mutate(
                stage, "agent", "start", state["name"], "--kind", "codex",
                "--pane", top, "--timeout", "30000", "--", *native, timeout=40,
            )
            agent = herdr("agent", "get", state["name"])["agent"]
            child_session = session_id(agent)
            live_cwd = agent.get("foreground_cwd") or agent.get("cwd")
            require(
                child_session != state["source_session"] and agent["pane_id"] == top
                and agent["workspace_id"] == workspace_id
                and bool(live_cwd) and Path(live_cwd).resolve() == Path(checkout),
                "The forked conversation does not match its destination.",
            )
            return child_session

        before = herdr(
            "pane", "read", top, "--source", "recent-unwrapped",
            "--lines", "120", "--format", "text",
        )["read"]["text"]
        try:
            child_session = start_fork("agent_started")
        except (ValueError, KeyError, subprocess.SubprocessError):
            output = herdr(
                "pane", "read", top, "--source", "recent-unwrapped",
                "--lines", "120", "--format", "text",
            )["read"]["text"]
            marker = "Update ran successfully! Please restart Codex."
            if output.count(marker) <= before.count(marker):
                raise
            pane = herdr("pane", "get", top)["pane"]
            process = herdr("pane", "process-info", "--pane", top)["process_info"]
            shell_pid = process.get("shell_pid")
            if not (
                pane["pane_id"] == top and pane["workspace_id"] == workspace_id
                and pane.get("agent") is None and process["pane_id"] == top
                and shell_pid is not None
                and [item["pid"] for item in process.get("foreground_processes", [])]
                == [shell_pid]
            ):
                raise
            state["update_restart"] = {"count": 1, "output": output}
            save()
            child_session = start_fork("agent_restarted_after_update")
        state["destination_session"] = child_session
        save()
        gate = (
            "Implementation is explicitly authorized only for the assigned ticket. "
            "Use build and wait for approval before each commit."
            if arguments.implement_authorized else
            "Prepare the reviewed plan and next ticket. "
            "Wait for the user's go before coding."
        )
        prompt = (
            f"This conversation was forked from {state['source_session']}. "
            "The active objective is now the handoff below. "
            "Earlier objectives are context. "
            f"Use worktree {checkout} and Herdr workspace {workspace_id}. "
            f"Keep canonical planning in {state['planning_store']}. "
            "Verify your own context and bindings. "
            "Report your session ID and canonical draft paths. "
            f"{gate}\n\n{arguments.handoff.read_text()}"
        )
        mutate(
            "handoff_submitted", "agent", "prompt", state["name"], prompt,
            "--wait", "--until", "working", "--timeout", "5000", timeout=10,
        )
        state["status"] = "working"
        save()
    except Exception:
        state["status"] = "incomplete"
        save()
        raise


def main() -> int:
    """Parse the handoff options and report setup or its incomplete stage."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cwd", type=Path, default=Path.cwd())
    parser.add_argument("--session")
    parser.add_argument("--branch", required=True)
    parser.add_argument("--base", required=True)
    parser.add_argument("--path", type=Path, required=True)
    parser.add_argument("--name", required=True)
    parser.add_argument("--label")
    parser.add_argument("--handoff", type=Path, required=True)
    parser.add_argument("--state", type=Path, required=True)
    parser.add_argument("--model")
    parser.add_argument("--planning-dir", type=Path)
    parser.add_argument("--implement-authorized", action="store_true")
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    state = {}
    try:
        state = preflight(arguments)
        if not arguments.check:
            setup(arguments, state)
        print(json.dumps(state, indent=2))
        return 0
    except (
        OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError
    ) as error:
        detail = (
            error.stderr
            if isinstance(error, subprocess.CalledProcessError) else str(error)
        )
        report = {"error": detail, "state_file": str(arguments.state), **state}
        print(json.dumps(report, indent=2), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
