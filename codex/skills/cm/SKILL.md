---
name: cm
description: Generate a concise conventional commit message from the staged git diff, copy it to the clipboard with pbcopy when available, and output only the quoted commit message. Use when the user asks for $cm, cm, a commit message, or staged-change commit wording.
---

# Commit Message

Generate exactly one commit message for the staged changes.

## Workflow

1. Verify the current directory is inside a git repository.
2. Inspect only staged changes:
   - `git diff --cached --name-status --no-renames`
   - `git diff --cached --stat --no-renames`
   - `git diff --cached --no-ext-diff`
3. If there is no staged diff, stop and say `no staged changes`.
4. Write one concise conventional commit message.
5. Copy the final quoted message to the clipboard with `pbcopy` when available:
   - `printf '%s' '"<message>"' | pbcopy`
6. Output only the final quoted commit message.

## Message Style

- Use conventional commit prefixes such as `feat:`, `fix:`, `docs:`,
  `test:`, `refactor:`, `build:`, `ci:`, `chore:`, or `revert:`.
- Choose the prefix from the staged diff, not from unstaged work.
- Keep it to one line.
- Prefer under 72 characters when it stays accurate.
- Use imperative, present-tense wording.
- Do not include explanations, alternatives, bullets, or diagnostics unless the
  user explicitly asks for them.

## Output

Return only:

```text
"<prefix>: <message>"
```
