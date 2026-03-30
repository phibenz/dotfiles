---
name: cm
description: Propose a short one-line conventional commit message for the currently staged changes. Use when the user says `$cm` or asks for a commit message for staged changes without creating or modifying any commits or files.
---

# Commit Message

Read the currently staged changes and propose exactly one concise commit message.

## Requirements

- Inspect staged changes only
- Do not stage files
- Do not unstage files
- Do not create a commit
- Do not modify any files
- After choosing the message, wrap it in double quotes for the final output
- If `uname` reports `Darwin` and `pbcopy` is available, copy that exact quoted one-line message to the clipboard with a shell command such as `printf '%s' "$quoted_message" | pbcopy`
- Output a single quoted one-line commit message and nothing else unless the user asks for alternatives

## Message style

- Use conventional commit prefixes when they fit: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`, `build:`, `ci:`
- Keep it specific to the staged diff
- Keep it short and not chatty
- Avoid trailing punctuation
- Prefer one scope-free line unless a scope is clearly useful

## Process

1. Inspect the staged diff with git
2. Infer the primary change
3. Store the final one-line message in a shell variable so it can be reused exactly
4. Wrap it in double quotes and store the quoted form in a second shell variable
5. If on macOS and `pbcopy` exists, copy the quoted message to the clipboard
6. Print the quoted one-line commit message
