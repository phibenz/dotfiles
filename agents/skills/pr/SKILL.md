---
name: pr
description: Create or update the current branch's GitHub pull request through a fast inline workflow, with optional background delegation and a generated title and description. Trigger when the user asks for $pr, pr, to open a PR, update PR title/body, PR wording, a pull request title, or a pull request description.
---

# Pull Request Upsert

Create the current branch's GitHub pull request if it does not exist. If it
already exists, update its title and body.

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
   path, and the ACP result for a combined request. Tell it to skip this section,
   execute the Workflow, and never spawn another subagent. Do not duplicate its
   mutations; wait for its result.
5. For a combined request, return only the concise ACP and PR results after both
   stages succeed.

When you are the delegated worker, skip this section and execute the Workflow directly.

## Workflow

1. Batch the initial local inspection into one tool call:
   - Run `git status --short --branch --untracked-files=all`. This verifies the
     repository and identifies the current branch. Stop on a detached HEAD.
   - Resolve the base with the Base Branch rules below. Stop if the current
     branch is the base branch.
   - Run `git log --oneline --no-decorate <base>...HEAD`,
     `git diff --name-status --no-renames <base>...HEAD`, and
     `git diff --stat <base>...HEAD`.
   - Use the conversation, commit subjects, changed paths, and diff stat first.
     Inspect `git diff --no-ext-diff <base>...HEAD` only when more detail is
     needed to write an accurate PR.
   - Run `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'` and
     `git remote`. Treat a missing upstream as expected.
2. If there are no committed branch changes, inspect untracked `docs/features/`
   before stopping with `no committed branch changes to open as a PR`.
3. Check for an existing PR with
   `GH_NO_UPDATE_NOTIFIER=1 gh pr view --json number,url,title,baseRefName`.
   Treat the normal no-PR result as the create path. If an existing PR reports
   a different base, use that base as authoritative and recompute the local
   change summary before updating it.
4. Query recent merged PR titles only when the repository's title style remains
   unclear from current context. Do not make this network request by default.
5. Generate one PR title and body.
6. If no PR exists, ensure the branch has a same-name remote upstream using the
   Push Target rules below.
7. Create or update the PR in one command. Pass the generated body through
   standard input with `--body-file -`; use a quoted heredoc delimiter so shell
   expansion cannot alter the Markdown:
   - Update: `GH_NO_UPDATE_NOTIFIER=1 gh pr edit <number> --title <title> --body-file -`
   - Create: `GH_NO_UPDATE_NOTIFIER=1 gh pr create --base <base-name> --head <current-branch> --title <title> --body-file -`

If a `gh` command fails because sandboxed execution cannot reach GitHub, retry
the same command with the required tool escalation and a concise user-facing
justification. Do not ask the user to reply with a magic sentence.

## Base Branch

- First use `git config --get branch.<current-branch>.gh-merge-base` when set.
  This records an explicitly requested stacked PR base.
- Otherwise prefer `refs/remotes/origin/HEAD`, then try `origin/main`,
  `origin/master`, `main`, and `master`.
- Use the remote ref for diffs and the branch name without the remote prefix for
  `gh pr create --base`.
- If a configured stacked base is missing locally, fetch that branch from
  `origin`. Never silently replace it with the default branch.

## Push Target

- Do nothing when the existing remote upstream branch exactly matches the local
  branch.
- Only when it is absent or mismatched, inspect the branch's push remote,
  `remote.pushDefault`, configured remote, `origin`, and sole remote in that
  order. Ignore `.` as a push target.
- When the remote is unambiguous, run
  `git push --set-upstream <remote> HEAD:refs/heads/<current-branch>`. If it is
  ambiguous, stop and ask the user which remote to use.

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
- Do not include a broad diff tour, validation or verification details, test
  logs, or implementation trivia unless the user explicitly asks.
- Do not include agent attribution, model attribution, emojis, or final playful
  notes. Commit trailers capture model involvement when needed.

## Output

After creating or updating the PR, return only the concise `gh` result or PR
URL. Do not print the generated title or body separately.
