---
name: pr
description: Create or update the current branch's GitHub pull request through a fast inline workflow, with optional background delegation and a generated title and description. Trigger when the user asks for $pr, pr, to open a PR, update PR title/body, PR wording, a pull request title, or a pull request description.
---

# Pull Request Upsert

Create the current branch's GitHub pull request if it does not exist. If it
already exists, update only the fields permitted by the request and repository rules.

Do not only print PR wording. The skill mutates the PR.

## Execution and Sequencing

When you are the parent agent:

1. Execute the Workflow directly by default.
2. For a combined `$acp` and `$pr` request, wait for ACP to push successfully
   before starting PR. Stop if ACP fails.
3. If the user explicitly requests background or delegated PR, spawn exactly one
   worker with `task_name = "pr_worker"`, `fork_turns = "none"`,
   `model = "gpt-5.6-terra"`, and `reasoning_effort = "low"`.
4. Give the worker the user request, working directory, this skill's absolute
   path, applicable repository rules, requested PR base, relevant stack context,
   and the ACP result for a combined request. Tell it to skip this section,
   execute the Workflow, and never spawn another subagent. Do not duplicate its
   mutations; wait for its result.
5. For a combined request, return only the concise ACP and PR results after both
   stages succeed.

When you are the delegated worker, skip this section and execute the Workflow directly.

## Workflow

1. Batch the initial inspection where possible:
   - Run `git status --short --branch --untracked-files=all`. This verifies the
     repository and identifies the current branch. Stop on a detached HEAD.
   - Run `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'` and
     `git remote`. Treat a missing upstream as expected.
   - Identify the destination repository and head repository; do not assume the
     push remote is the PR destination. Check the current branch's existing PR
     with `GH_NO_UPDATE_NOTIFIER=1 gh pr view --json number,url,title,body,baseRefName`.
     Confirm the lookup targets that repository and branch. Only a normal no-PR
     result selects the create path; surface other failures.
2. Resolve the Base Branch before calculating changes or deciding there are none.
   Stop if the current branch is the resolved base.
3. Use the resolved `<base-ref>` for `git log --oneline --no-decorate <base-ref>..HEAD`,
   `git diff --name-status --no-renames <base-ref>...HEAD`, and
   `git diff --stat <base-ref>...HEAD`. Inspect the full diff only when needed.
   If no PR exists and there are no committed branch changes, stop without creating
   a PR. An empty diff alone does not prevent a requested update to an existing PR.
4. Query recent merged PR titles only when the repository's title style remains
   unclear from current context. Do not make this network request by default.
5. Prepare the permitted title, body, and labels under repository rules.
6. Before creation, verify the resolved base exists on the destination repository,
   not merely locally or on a fork. Stop if it is missing; do not publish it.
   Check Stack Publication prerequisites when linking is requested. Ensure the
   current branch has a same-name remote upstream using the Push Target rules.
7. Create or update the PR in one command. Pass the generated body through
   standard input with `--body-file -`; use a quoted heredoc delimiter so shell
   expansion cannot alter the Markdown:
   - Update: `GH_NO_UPDATE_NOTIFIER=1 gh pr edit <number> --title <title> --body-file -`.
     Omit protected fields. Add `--base <base-name>` only for an explicitly
     authorized retarget, after resolving conflicts and verifying the remote base.
   - Create: `GH_NO_UPDATE_NOTIFIER=1 gh pr create --base <base-name> --head <head> --title <title> --body-file -`.
     Use the current branch for `<head>`, qualified with its owner for a fork.
   - Target the verified destination with `--repo` when needed. Apply required labels.
8. After creation, perform Stack Publication only when it is within the request.

If sandbox restrictions prevent a `gh` request, use tool escalation with a concise
justification. If a mutation's outcome is uncertain, inspect remote state before
retrying. Never repeat successful PR creation to recover failed stack linking.

## Base Branch

- Collect the user's explicit base, the existing PR's `baseRefName`,
  `git config --get branch.<current-branch>.gh-merge-base`, and the stack parent.
  A missing config key is normal; other config errors are not.
- Read the `gh-stack` skill when available. Inspect `gh stack view --json`.
  An unavailable extension or a confirmed "not in a stack" result permits fallback.
  Surface other failures and stop base resolution. Do not blanket-ignore errors:
  installed versions can also use exit 2 for invalid or unreadable stack state.
- Match the current branch in the ordered `branches` list. The first branch's
  parent is `trunk`; each later branch's parent is the preceding entry's `name`.
  `branches[].base` is a saved commit SHA, never a branch name. Ambiguous or
  inconsistent metadata requires resolution, not a default-branch fallback.
- Report disagreeing sources and their bases before any PR mutation. An explicit
  user instruction selects the base and can authorize retargeting the current PR.
  Without that instruction, stop and resolve the conflict with the user. Do not
  silently retarget an existing PR or rewrite local stack metadata.
- With no conflict, use the explicit base, existing PR base, configured base, or
  stack parent, in that order. Use the destination repository's default branch
  only when all four are absent; query its default instead of guessing `main`.
- Keep `<base-name>` separate from `<base-ref>`. Fetch the exact destination branch
  into a remote-tracking ref or `FETCH_HEAD`. Use that ref for summaries and diffs,
  and the branch name for `--base`. Never replace an unavailable parent with the default.
  Do not check out or update a local parent, including one in another worktree.

## Stack Publication

- Local stack tracking does not create GitHub stack grouping. Link only when the
  request includes stack publication; local membership alone is not authorization.
- Check the installed `gh stack link --help` before choosing the command. Version
  0.0.8 supports the procedures below. Verify repository selection and remote
  identity; a PR URL does not select the command's destination repository.
- Resolve existing parent PRs and remote stack membership before creation. If a
  required parent PR is missing, stop and report it; never create it implicitly.
  The bottom branch needs no trunk PR. If it is the only published layer, create
  its ordinary PR and defer grouping until another layer exists.
- Use verified PR URLs, or verified PR numbers with no local branch-name collision.
  Prefer URLs: branch arguments can push branches and create missing PRs; numeric
  arguments can fall back to branch names. Never pass parent branch names.
- For a new group, pass existing PR URLs bottom-to-top through the new PR:
  `gh stack link --remote <remote> --base <trunk> <bottom-pr-url> ... <new-pr-url>`.
  For an existing group whose top is the resolved parent, append with
  `gh stack link --remote <remote> <stack-number> <new-pr-url>`.
  If that append condition fails, stop rather than reorder or synchronize the stack.
- Before linking, verify every affected PR already has the expected base. `link`
  can retarget existing PRs; do not use it to resolve conflicts or change unrelated
  PRs. An explicit base that differs from the local chain needs a compatible
  publication plan before linking. Do not add `--open` unless requested.
- Verify remote membership and bases after linking; warnings can accompany a zero
  exit status. If creation succeeds but linking fails, report the new PR URL and
  the separate linking failure. Do not recreate the PR or retry with broader commands.

## Push Target

- Push the current branch to its same-name remote branch, never to its PR parent.
  Keep ordinary Git pushes; do not use `gh stack push`, `submit`, or `sync`, or
  automatically rebase, synchronize, or publish parent branches.
- Do nothing when the existing remote upstream branch exactly matches the local
  branch.
- Only when it is absent or mismatched, inspect the branch's push remote,
  `remote.pushDefault`, configured remote, `origin`, and sole remote in that
  order. Ignore `.` as a push target.
- When the remote is unambiguous, run
  `git push --set-upstream <remote> HEAD:refs/heads/<current-branch>`. If it is
  ambiguous, stop and ask the user which remote to use.
- On rejection, stop and report it. Do not pull, merge, rebase, amend, force-push,
  or retry without user authorization. Repository force-push restrictions still apply.

## Title Style

- Follow the repository's recent PR title conventions when they are visible.
- If no clear convention is visible, use a concise descriptive title.
- Use conventional prefixes only when the repository commonly does so or the
  branch changes clearly fit that style.
- Keep the title to one line, preferably under 72 characters.

## Body Style

- Use as many bullets as are useful, usually 2-4. Do not force exactly three.
- Make each bullet descriptive and easy to understand in simple words.
- Focus on what changed and why it matters.
- When the PR implements one or more specific Linear tickets, append one
  separate `Fixes <ISSUE-ID>` line for each ticket. Resolve ticket IDs from the
  user request, current conversation, branch name, commit subjects, changed
  feature-design paths, and an existing PR body. Do not guess an issue ID.
- Do not include a broad diff tour, validation or verification details, test
  logs, or implementation trivia unless the user explicitly asks.
- Do not include agent attribution, model attribution, emojis, or final playful
  notes. Commit trailers capture model involvement when needed.

## Output

Return the PR URL and, when requested, the stack-link result. Report partial
success and unresolved prerequisites separately. Do not print generated wording.
