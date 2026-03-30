---
name: pr
description: Propose a PR title and concise PR description for the current branch compared to its base branch. Use when the user says `$pr` or asks for a pull request title/description without opening or modifying the PR.
---

# Pull Request Summary

Inspect the current branch against its base branch and propose:

1. A one-line PR title
2. A short PR description

## Requirements

- Inspect git history and diff only
- Do not create or update a PR
- Do not modify any files
- Keep the output concise, direct, and easy to understand
- Follow common title conventions such as `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`, `build:`, `ci:` when they fit

## Base branch selection

Choose the base branch in this order:

1. The current branch's upstream default branch if it is clear from git metadata
2. `origin/HEAD`
3. `origin/main`
4. `origin/master`
5. `main`
6. `master`

If no reasonable base branch can be determined, ask the user which base branch to use.

## Process

1. Determine the current branch and base branch
2. Inspect the diff and commit summary between `base...HEAD`
3. Infer the primary user-facing change
4. Print output in this format:

```md
Title: <concise conventional PR title>

Description:
- <short summary of the main change>
- <short summary of any important supporting change>
- <optional note about tests, risk, or follow-up only if it materially helps>
```

## Style

- Prefer 2 bullets in the description, 3 only when needed
- Avoid fluff and implementation trivia
- Make the description understandable without reading the diff
