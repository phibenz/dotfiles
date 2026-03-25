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
- Output a single one-line commit message and nothing else unless the user asks for alternatives

## Message style

- Use conventional commit prefixes when they fit: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`, `build:`, `ci:`
- Keep it specific to the staged diff
- Keep it short and not chatty
- Avoid trailing punctuation
- Prefer one scope-free line unless a scope is clearly useful

## Process

1. Inspect the staged diff with git
2. Infer the primary change
3. Print one commit message
