---
name: wtrm
description: Safely remove a named linked Git worktree, close its Herdr workspace, and archive its exact Codex session while preserving the Git branch. Use when the user invokes $wtrm, asks to clean up a wt-created worktree, or provides a worktree name for coordinated cleanup. Do not use for the main checkout or permanent Codex session deletion.
---

# Worktree Cleanup

Remove a completed worktree and its runtime state without deleting committed work or Codex history.

## Target Resolution

1. Require a worktree name or absolute path. If it is missing, list linked worktree basenames and ask for one.
2. Resolve the current Git repository with `git rev-parse --show-toplevel` and inspect:
   - `git worktree list --porcelain`
   - `herdr worktree list --cwd <current-top-level>`
   - `herdr agent list`
3. Match the input only against an exact absolute worktree path or exact path basename. Never use a partial or fuzzy match.
4. Require exactly one linked, non-bare worktree. Never select the repository's main checkout.
5. Refuse to remove the checkout that contains the cleanup agent's current working directory. Tell the user to run the cleanup from another checkout.

## Safety Check

Before requesting authorization, establish all cleanup targets:

1. Run `git -C <target-path> status --porcelain=v1 --untracked-files=all`. Stop if it returns any path. Never stash, clean, reset, or force removal.
2. Record the exact worktree path, branch, HEAD, and Herdr `open_workspace_id` from structured output. The branch is retained.
3. Find the Codex agent by exact target path or exact Herdr workspace ID. Stop if a matching agent is working or if multiple Codex agents match.
4. Prefer the exact UUID in the matching agent's `agent_session.value` when its source is `herdr:codex`.
5. Confirm the session against `${CODEX_HOME:-${HOME}/.codex}/state_5.sqlite`: require `threads.id` to match the UUID, `cwd` to equal the target path, `source` to equal `cli`, and `archived` to equal `0`. Record its `rollout_path`.
6. If Herdr has no session UUID, query unarchived `cli` threads by exact `cwd`. Use the result only when exactly one session matches. Stop and ask the user if none or multiple match.
7. Ignore subagent thread rows. Archive only the root `cli` session associated with the Herdr Codex agent.

Show one preview with the exact path, branch, workspace ID, and Codex session UUID. State that cleanup removes the checkout, closes its Herdr workspace, archives the session, and retains the branch. Ask for confirmation immediately before mutation. An explicit `--yes` in the current request can provide this confirmation.

## Cleanup

After confirmation:

1. When the worktree has an open Herdr workspace, run `herdr worktree remove --workspace <workspace-id>` without `--force`. This closes the workspace and removes the checkout.
2. When no Herdr workspace exists, run `git worktree remove -- <target-path>` without `--force`.
3. Confirm the target is absent from both `git worktree list --porcelain` and `herdr worktree list --cwd <source-top-level>`.
4. Run `lsof <rollout-path>` before archiving. If any process still holds the session file, stop and report the partial cleanup. Never kill the holder automatically.
5. Run `codex archive <session-uuid>`. Archiving is reversible with `codex unarchive`.
6. Confirm the session row has `archived = 1` and the retained branch still exists.

Never run `herdr worktree remove --force`, `git worktree remove --force`, `git branch -d`, `git branch -D`, `codex delete`, or delete a session JSONL file. If a command fails after removing the worktree, report the completed removals and the exact remaining step. Do not recreate or roll back the worktree automatically.

## Output

Report the removed worktree path, closed Herdr workspace ID, archived Codex session UUID, and retained branch.
