---
name: cm
description: Generate a concise conventional commit message from the staged git diff, include Codex model co-author attribution, copy it to the clipboard with pbcopy when available, and optionally commit it. Use when the user asks for $cm, cm, $cmc, cmc, a commit message, or staged-change commit wording.
---

# Commit Message

Generate exactly one commit message for the staged changes.

`cm` writes the message and copies it to the clipboard. `cmc` uses the same
message generation flow, then creates the commit.

## Workflow

1. Verify the current directory is inside a git repository.
2. Inspect only staged changes:
   - `git diff --cached --name-status --no-renames`
   - `git diff --cached --stat --no-renames`
   - `git diff --cached --no-ext-diff`
3. If there is no staged diff, stop and say `no staged changes`.
4. Write one concise conventional commit subject.
5. Add a blank line and then a Codex model attribution trailer:
   - `Co-authored-by: <model> <noreply@openai.com>`
   - Use the active Codex model display name plus reasoning effort when known,
     such as `GPT-5.5 medium`.
   - If the reasoning effort is unavailable, use the active model display name
     alone.
6. Copy the full final commit message to the clipboard with `pbcopy` when
   available:
   - `printf '%s' '<subject>\n\nCo-authored-by: <model> <noreply@openai.com>' | pbcopy`
7. For `cm`, output only the final commit message.
8. For `cmc`, create the commit with the generated message:
   - `git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>"`
   - Forward any user-provided `git commit` flags such as `--amend` or
     `--no-verify`.
   - After the commit succeeds, report only the commit command's concise result
     or the created commit summary. Do not also print a separate explanation.

## Message Style

- Use conventional commit prefixes such as `feat:`, `fix:`, `docs:`,
  `test:`, `refactor:`, `build:`, `ci:`, `chore:`, or `revert:`.
- Choose the prefix from the staged diff, not from unstaged work.
- Keep the subject to one line.
- Prefer under 72 characters when it stays accurate.
- Use imperative, present-tense wording.
- Do not include explanations, alternatives, bullets, or diagnostics unless the
  user explicitly asks for them.

## Output

For `cm`, return only:

```text
<prefix>: <message>

Co-authored-by: <model> <noreply@openai.com>
```

For `cmc`, run the commit instead of returning a standalone message.
