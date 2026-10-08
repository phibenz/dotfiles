---
name: fork
description: Fork the current coding conversation into a linked worktree and Herdr workspace for a new feature or separate prerequisite. Use when separating work objectives or starting feature work from the origin checkout. Preserve the source work and continue only the assigned objective.
---

# Fork Work into Its Own Workspace

Create the new worktree and Herdr workspace, then fork the current conversation into it.
The new agent owns the assigned objective. The source agent retains its existing objective.

Read [PR Workspaces](../ticket/references/workspaces.md) for feature boundaries and bindings.
Read [Manage Local Planning Files](../ticket/references/drafts.md) for canonical origin storage.

## 1. Define the handoff

- Accept the new feature request or the existing ticket's absolute path.
- For a discovered prerequisite, record why the current feature needs it and which work must wait.
- Keep discovery and dependency notes in the source context. Move detailed prerequisite planning and code to the destination.
- A requested new feature or accepted prerequisite authorizes this setup under the workflow's default isolation rule.
- If the prerequisite changes the agreed outcome or compatibility promises, resolve that decision before assigning its work.
- Setup does not authorize implementation, commits, pushes, or publication.
- Capture the exact source session ID before starting another agent. Prefer `CODEX_THREAD_ID` and verify it against caller session metadata.
- If the ID is unavailable, resolve the caller by exact checkout and active session evidence. Do not choose by title or recency.
- If the source session is ambiguous, return a handoff without starting a different conversation.
- Include the destination objective, exclusions, canonical planning paths when assigned, origin, base commit, and source session ID.
- State the destination mode: prepare a reviewed plan and next ticket, or use an already reviewed ticket with its recorded approval status.
- Record current findings as evidence. Do not treat inherited implementation instructions as permission to build the new feature.

## 2. Select and check the destination

- Read the installed Herdr guidance and relevant command help. Require `HERDR_ENV=1` before control commands.
- Verify the caller workspace, source checkout, branch, HEAD, index, and existing changes.
- Resolve the canonical origin through the storage helper. Preserve its path across the fork.
- Choose the base from the new objective's actual prerequisites.
- A prerequisite normally starts from the original feature's prerequisite base, without that feature's unfinished changes.
- A new unrelated feature uses its own target base.
- Do not copy dirty source files, commit unfinished work, or switch the source branch to create the destination.
- If the destination needs uncommitted source changes, resolve the dependency boundary before starting it.
- Inspect existing feature drafts and owners before creating duplicate prerequisite work. Resolve a dependency cycle instead of recursively forking it.
- Verify branch, path, workspace, and agent-name availability. Preserve existing destinations. Verify an earlier handoff before reusing one.
- Place the destination outside the source and origin checkouts. Nested worktrees would change the source checkout's contents.
- Avoid creating a second workspace when the user already supplied the correct isolated destination.
- Verify the source model, sandbox, and approval settings before startup. Do not add sandbox bypass flags or expand origin code access.
- Resolve required planning access before startup. Grant only the canonical local planning folder through approved execution options.
- Storage initialization also writes the shared Git `info/exclude`. Use approved helper execution for that mutation when the sandbox requires it.
- Planning-folder access alone does not authorize Git metadata writes. Do not grant the entire origin checkout to avoid this distinction.
- Resolve missing origin access before writing planning files. Never create a worktree-local planning store.

## 3. Choose one setup route

### Default: run the fork script

Use [fork_work.py](scripts/fork_work.py) for a new destination. It creates the worktree and workspace, splits the panes, starts the fork, and submits the handoff.
Do not perform the manual setup actions before or after a successful script run.

```text
python3 <fork-skill>/scripts/fork_work.py \
  --branch <branch> --base <verified-base> --path <new-worktree> \
  --name <agent-name> --handoff <handoff-file> --state <local-state-file>
```

- Write the handoff file before running the script. Keep it and the state file in canonical local evidence or a temporary folder.
- Use `--check` for read-only preflight without creating a destination or state file.
- The default handoff stops after reviewed planning. Pass `--implement-authorized` only when the user explicitly authorized the assigned ticket's implementation.
- Pass `--model` when preserving an explicit current model choice. The script otherwise uses the native fork configuration.
- If approved planning access exists, pass its canonical folder with `--planning-dir`. The script rejects access outside the planning store.
- The script records each mutation before execution. Inspect incomplete state before recovery. Never rerun blindly with another state file.
- If Codex updates successfully and exits to the shell, the script restarts the same fork command once in the existing top pane.
- The script requires a new update-success message and live shell evidence before restarting. Other failures retain incomplete state for inspection.
- The script uses native fork configuration and does not verify permission inheritance. Use the manual route when startup requires explicit verified source settings.

For an existing destination or required explicit startup settings, read [Manual Setup and Recovery](references/manual.md) instead.

## 4. Verify and report either route

- Verify the destination's distinct session ID, checkout, branch, base, workspace, and top pane through live metadata.
- Verify prompt delivery and agent activity. Do not submit the handoff again after successful delivery.
- Do not equate a ready terminal with completed planning.
- The destination must verify its own ticket binding and base. Do not copy the source ticket's workspace binding to another ticket.
- Preserve explicit approval for the assigned ticket. Approval for the source feature does not authorize a separate prerequisite or another ticket.
- Ask the destination to report its canonical draft paths. Record prerequisite and dependent links in both features when those drafts exist.
- Record verified destination IDs and paths in canonical local metadata when available. Keep an unassigned feature's handoff in the conversation until its draft exists.
- Report the destination and what the new agent is doing. Keep user focus in the source workspace unless requested otherwise.

## 5. Preserve the source

- The source agent does not implement the destination feature. Pause dependent work and continue only independent work within the source objective.
- For incomplete setup, read [Manual Setup and Recovery](references/manual.md) before another control command.
- Keep source files, index, branch, session, and workspace intact. Cleanup requires a separate request.
- If forking or Herdr control is unavailable, provide the exact handoff and report the missing capability.
- Do not substitute a fresh conversation silently or continue the new objective in the origin or source worktree.
- When the prerequisite finishes, return to the source context and use [Reconcile the Remaining Plan](../plan/references/reconcile.md).

The [official CLI reference](https://learn.chatgpt.com/docs/developer-commands?surface=cli) documents transcript-preserving forks and directory selection.
