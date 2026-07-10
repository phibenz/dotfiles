---
name: pr
description: Use this skill to create or update the current branch's GitHub pull request with a generated title and description. Trigger when the user asks for $pr, pr, to open a PR, update PR title/body, PR wording, a pull request title, or a pull request description.
---

# Pull Request Upsert

Create the current branch's GitHub pull request if it does not exist. If it
already exists, update its title and body.

Do not only print PR wording. The skill mutates the PR.

## Workflow

1. Verify the current directory is inside a git repository and `gh` is
   available.
2. Determine the current branch.
   - Stop if it is empty or detached.
   - Stop if it is the base branch itself.
3. Determine the likely base branch.
   - Prefer `refs/remotes/origin/HEAD` when available.
   - Otherwise try `origin/main`, `origin/master`, `main`, then `master`.
   - Use the remote ref for diffs.
   - Use the branch name without the remote prefix for `gh pr create --base`
     (for example, diff against `origin/main`, create against `main`).
4. Inspect all committed branch changes compared to the base branch:
   - `git log --oneline --no-decorate <base>...HEAD`
   - `git diff --name-status --no-renames <base>...HEAD`
   - `git diff --stat <base>...HEAD`
   - `git diff --no-ext-diff <base>...HEAD`
   - If the committed diff is empty, inspect untracked `docs/features/` before
     concluding there is no PR material. If there are still no committed
     changes, stop and say there are no committed branch changes to open as a
     PR.
5. Check recent merged PR titles when `gh` is available, and use them only as a
   style reference:
   - `GH_NO_UPDATE_NOTIFIER=1 gh pr list --state merged --limit 8 --json title --jq '.[].title'`
6. Generate one PR title and body.
7. Write the generated body to a temporary file so shell quoting cannot corrupt
   markdown.
8. Check whether the current branch already has a PR:
   - `GH_NO_UPDATE_NOTIFIER=1 gh pr view --json number,url`
9. If a PR exists, update it:
   - `GH_NO_UPDATE_NOTIFIER=1 gh pr edit <number> --title <title> --body-file <body-file>`
10. If no PR exists, create it:
   - Ensure the current branch has an upstream. If it does not, run
     `git push -u origin HEAD`.
   - `GH_NO_UPDATE_NOTIFIER=1 gh pr create --base <base-name> --head <current-branch> --title <title> --body-file <body-file>`
11. Remove the temporary body file.

If a `gh` command fails because sandboxed execution cannot reach GitHub, retry
the same command with the required tool escalation and a concise user-facing
justification. Do not ask the user to reply with a magic sentence.

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
- Do not include a broad diff tour, test logs, or implementation trivia unless
  the user explicitly asks.
- Mention verification only when it is a meaningful part of the branch changes
  or the user asked for it.
- Do not include agent attribution, model attribution, emojis, or final playful
  notes. Commit trailers capture model involvement when needed.

## Output

After creating or updating the PR, return only the concise `gh` result or PR
URL. Do not print the generated title or body separately.
