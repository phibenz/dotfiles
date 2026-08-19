---
name: wt
description: Create a task-named sibling Git worktree from a freshly fetched origin/main, register it as a Herdr workspace, split its initial terminal into equal left and right panes, and start a Codex agent in the right pane. Run inline by default and delegate only when the user explicitly requests background execution. Use when the user invokes $wt, says wt, asks for a new worktree with a Herdr window, or wants an isolated worktree and paired Codex pane for a task.
---

# Worktree

Create the worktree and Herdr layout as one workflow. Preserve the source checkout and the user's current Herdr focus.

## Execution

Execute the complete workflow directly by default. Do not start a subagent only because the user invokes this skill.

When the user explicitly requests background execution or invokes `$wt background`, delegate the complete workflow to exactly one background subagent:

1. Spawn it with `fork_turns = "none"`, `model = "gpt-5.6-terra"`, and `reasoning_effort = "low"`.
2. Include the user's task, the current working directory, and this skill's absolute path in the prompt. Tell the worker to read the skill, skip this Execution section, execute the Workflow directly, and never spawn another subagent.
3. Do not duplicate the worker's Git or Herdr mutations. Keep the worker running in the background, surface any approval request, and report completion only after you receive and verify its result.

When you are the delegated worker, skip this section and execute the Workflow directly.

Use the fewest tool calls that the data dependencies permit. Batch independent read-only checks. Continue through successful dependent steps without extra status updates. Do not repeat successful commands only to verify them.

## Naming

1. Treat the current Git top-level directory as the source directory.
2. Derive a concise kebab-case task slug that describes the work. Never use a generic suffix such as `worktree`, `wktree`, or only a number.
3. Use the source directory's basename as the folder prefix. If it is longer than seven characters, truncate it to its first seven characters.
4. Name the new folder `<source-prefix>-<task-slug>` and place it beside the source directory.

Examples:

- `/work/app` plus `fix-login` becomes `/work/app-fix-login`.
- `/work/catalog-service` plus `add-metrics` becomes `/work/catalog-add-metrics`.

Choose a fresh branch name from the task and the repository's existing user/branch convention. If no convention is visible, use `<user>/<task-slug>`. Keep folder naming independent of branch slashes.

## Workflow

1. Verify the prerequisites before mutating anything:
   - Confirm the current directory is inside a Git worktree and resolve its absolute top-level directory.
   - Require `HERDR_ENV=1` and `HERDR_WORKSPACE_ID`. If either is absent, stop before creating the worktree and explain that `$wt` must run inside a Herdr workspace.
   - In one read-only batch, inspect `git status --short --branch`, `git worktree list --porcelain`, the `origin` remote, the proposed branch and path, and `herdr agent list`.
   - Treat all staged, unstaged, and untracked source changes as excluded. Leave them untouched, even when they relate to the task. Do not ask whether to copy them into the new worktree.
2. Resolve collisions safely:
   - Require both a new branch and a nonexistent target path.
   - If either collides, choose another descriptive task slug when intent is clear; otherwise ask the user.
   - Never delete, prune, reuse, reset, or overwrite an existing branch, path, worktree, workspace, tab, or pane.
   - Derive a useful unique agent name from the task slug, valid for `[a-z][a-z0-9_-]{0,31}`. Add a short suffix if `herdr agent list` shows a collision.
3. Refresh the base and create the sibling checkout:
   - Run `git fetch origin`, then resolve `refs/remotes/origin/main` to an exact commit. Stop if the fetch or resolution fails. Never fall back to local `main`, the current `HEAD`, or a stale remote-tracking ref.
   - Run `git worktree add -b <branch> <target-path> <origin-main-commit>`.
   - Run these dependent Git steps in one tool call when practical.
4. Register the checkout with Herdr:
   - Treat `HERDR_WORKSPACE_ID` as the source workspace ID.
   - Run `herdr worktree open --workspace <source-workspace-id> --path <target-path> --label <folder-name> --no-focus`.
   - Read the workspace ID and root pane ID from the JSON response. Never infer IDs from ordering.
5. Split the root pane into equal left and right panes:
   - Run `herdr pane split --pane <root-pane-id> --direction right --ratio 0.5 --cwd <target-path> --no-focus`.
   - Read the new right pane ID from the JSON response.
6. Start Codex in the right pane:
   - Run `herdr agent start <agent-name> --kind codex --pane <right-pane-id> --timeout 120000`.
7. Accept the successful command results as the normal verification:
   - A successful `git worktree add` from the resolved commit establishes the branch, path, base, and clean checkout.
   - The structured `worktree open` and `pane split` responses establish the workspace, pane IDs, direction, and ratio.
   - A successful `herdr agent start` establishes agent readiness. The timeout is a limit, not a required wait.
   - Run `git status`, `git rev-parse`, `herdr pane layout`, `herdr pane neighbor`, or `herdr agent get` only when output is missing, inconsistent, or needed to diagnose a retry.

If sandboxing blocks the sibling path, shared Git metadata, or Herdr socket, request narrowly scoped escalation and retry the same operation. If a later step fails after the worktree is created, preserve the partial result and report the completed IDs and exact failing step; do not roll it back automatically. On a retry, inspect the existing Herdr workspace and panes before creating more layout.

## Output

Report only the new worktree path, branch and base, Herdr workspace and pane IDs, and Codex agent name/readiness.
