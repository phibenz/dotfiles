---
name: pr
description: Generate a pull request title and short bullet description from all changes on the current branch compared to the base branch. Use when the user asks for $pr, pr, PR wording, a pull request title, or a pull request description.
---

# Pull Request Wording

Generate a concise PR title and description for the current branch.

## Workflow

1. Verify the current directory is inside a git repository.
2. Determine the likely base branch.
   - Prefer `refs/remotes/origin/HEAD` when available.
   - Otherwise try `origin/main`, `origin/master`, `main`, then `master`.
   - Preserve remote refs such as `origin/main`; do not strip them to local
     branch names.
3. Inspect all branch changes compared to the base branch:
   - `git log --oneline --no-decorate <base>...HEAD`
   - `git diff --name-status --no-renames <base>...HEAD`
   - `git diff --stat <base>...HEAD`
   - `git diff --no-ext-diff <base>...HEAD`
4. Check recent merged PR titles when `gh` is available, and use them only as a
   style reference:
   - `GH_NO_UPDATE_NOTIFIER=1 gh pr list --state merged --limit 8 --json title --jq '.[].title'`
5. Produce one PR title and a short description.

## Title Style

- Follow the repository's recent PR title conventions when they are visible.
- If no clear convention is visible, use a concise descriptive title.
- Use conventional prefixes only when the repository commonly does so or the
  branch changes clearly fit that style.
- Keep the title to one line, preferably under 72 characters.

## Description Style

- Use only a few bullets.
- Focus on what changed and why it matters.
- Do not include a broad diff tour, test logs, or implementation trivia unless
  the user explicitly asks.
- Mention verification only when it is a meaningful part of the branch changes
  or the user asked for it.

## Output

Return only:

```md
<PR title>

- <bullet>
- <bullet>
- <bullet>
```
