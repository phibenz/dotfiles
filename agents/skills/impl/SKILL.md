---
name: impl
description: Use this skill to implement a requested change from a Linear feature-design ticket, a completed readiness review, or the current chat context. Trigger when the user invokes $impl, says impl, or asks to start implementation using the established ticket or conversation instructions. Always create a new phil/... branch before editing code, and support a stacked branch or PR base only when the current impl request explicitly asks for one.
---

# Implement

Implement the established request completely in the current repository. Resolve
the contract, create the implementation branch, edit the code, and run focused
verification. Do not repeat feature design or readiness work that the user has
already completed.

## Inputs

- Treat `$ARGUMENTS` and the current conversation as the implementation
  contract.
- Accept an optional Linear id matching `[A-Z][A-Z0-9]*-[0-9]+`.
- Run Linearis authentication checks and issue commands with network access
  outside the sandbox. If a sandboxed `auth status` reports
  `authenticated: false`, retry with network access before treating the token
  as invalid.
- When a ticket is identified, read its current body with Linearis. Prefer its
  `## Agent` section, incorporating decisions from a later readiness review or
  user message. Later explicit user instructions take precedence.
- When no ticket is identified, implement from the current conversation. Do not
  require a ticket and do not invent one.
- Ask only about an ambiguity that would make implementation unsafe or materially
  change behavior. Otherwise choose the smallest professional solution that fits
  the live codebase.

Example invocations:

- `$impl RL-635`
- `$impl implement the change described above`
- `$impl RL-635, stack on PR #482`

## Branch First

Create a new branch before modifying files. Read-only discovery needed to resolve
the request, base, and branch name may happen first.

1. Confirm the current directory is in the intended git worktree. Inspect the
   current branch, worktree status, remotes, and default branch.
2. Resolve the base:
   - If this `$impl` invocation explicitly says to stack on a PR or branch, use
     that PR's head branch or the named branch as the base. Resolve PR numbers or
     URLs with `gh pr view`, verify the head belongs to the same repository, and
     fetch the branch when necessary.
   - Otherwise use the repository's default branch, preferring
     `refs/remotes/origin/HEAD`, then `origin/main`, `origin/master`, `main`, or
     `master`.
   - Do not infer stacking from an older or unrelated conversation mention. The
     current `$impl` request must state it.
3. Derive a short lowercase kebab-case title from the ticket title or requested
   change. Remove punctuation, repeated separators, and a redundant ticket id.
4. Create the branch with exactly one of these shapes:
   - With a ticket: `phil/<lowercase-ticket-id>/<branch-title>`
   - Without a ticket: `phil/<branch-title>`

   The no-ticket form has exactly one slash. For example:
   `phil/rl-635/add-runtime-attachments` or
   `phil/add-runtime-attachments`.
5. Create the branch from the resolved base with
   `git switch --no-track -c <new-branch> <resolved-base>`. The `--no-track`
   option prevents the feature branch from inheriting the base branch as its
   upstream. Do not reuse, reset, or overwrite an existing branch of the same
   name.
6. For an explicitly stacked implementation, record the future PR base:

   ```sh
   git config branch.<new-branch>.gh-merge-base <stack-base-branch>
   ```

   This allows the later `$pr` workflow to target the parent branch. Do not set
   `gh-merge-base` for an ordinary implementation.

If pre-existing worktree changes cannot safely move to the resolved base, stop
and ask how to handle them. Never stash, discard, reset, or absorb unrelated
changes automatically.

## Implement

1. Inspect the live code paths, repository instructions, nearby patterns, tests,
   and current diff before choosing the edit.
2. Reuse existing abstractions and keep the change as small as the requested
   behavior permits.
3. Implement the full contract, including relevant error handling, compatibility,
   migrations, docs, or tests when the actual risk requires them.
4. Preserve unrelated dirty files and edits.
5. Run focused tests and static checks for the changed path. Expand verification
   only when the change's risk warrants it.
6. Review the final diff for scope, correctness, and accidental changes.

Do not commit, push, or create a PR unless the user also asks for that action.
An explicit stacking request configures the branch and future PR base; it does
not by itself open the PR.

## Report

Lead with the completed behavior. Include the new branch name, concise change
summary, verification performed, and any genuine remaining limitation. If the
branch is stacked, name its configured PR base.
