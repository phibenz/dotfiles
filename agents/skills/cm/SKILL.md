---
name: cm
description: Use this skill to commit the intended current changes with a concise conventional commit message and active model co-author attribution. It can stage unstaged files when the intended scope is clear, including mixed staged/unstaged work; it must avoid staging unrelated work. Trigger when the user asks for $cm, cm, a commit message, staged or unstaged commit wording, or to commit current changes.
---

# Commit Message

Stage the intended changes when needed, then generate and run exactly one commit
command.

`cm` creates the commit directly.

## Workflow

1. Verify the repo and inspect dirty state:
   - `git rev-parse --is-inside-work-tree`
   - `git status --short --untracked-files=all`
2. Choose the complete commit scope using the Scope Rules below.
3. If relevant changes are unstaged, inspect them just enough to confirm scope,
   then stage explicit pathspecs with `git add -- <pathspecs>`.
4. Inspect the final staged diff for the message:
   - `git diff --cached --no-ext-diff`
   If there is still no staged diff, stop and say `no changes to commit`.
5. Write one concise conventional commit subject and active model attribution:
   - `Co-authored-by: <model> <noreply@openai.com>`
   - Use the active model display name plus reasoning effort when known, such
     as `GPT-5.5 medium`.
   - If the reasoning effort is unavailable, use the active model display name.
6. Run the commit with two `-m` arguments:
   - `git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>"`
   - Escape quotes and shell-sensitive characters inside each argument so the
     command executes correctly.
   - Forward any user-provided `git commit` flags such as `--amend` or
     `--no-verify`.
7. After the commit succeeds, report only the commit command's concise result
   or the created commit summary. Do not also print a separate explanation.

## Scope Rules

- Infer scope from the user's request, conversation context, staged files, and
  dirty file list.
- Treat staged files as evidence, not a boundary; stage unstaged files from the
  same intended change set.
- Stage explicit pathspecs only. Never use `git add .` or broad directories
  unless the user clearly asked for that whole directory.
- Leave unrelated, older, local settings, editor, generated, and separate-docs
  changes unstaged unless the context clearly includes them.
- If multiple coherent change groups remain or scope is unclear, ask which files
  to include instead of guessing.

## Message Style

- Use conventional commit prefixes such as `feat:`, `fix:`, `docs:`,
  `test:`, `refactor:`, `build:`, `ci:`, `chore:`, or `revert:`.
- Choose the prefix from the staged diff after any scoped staging.
- Keep the subject to one line.
- Prefer under 72 characters when it stays accurate.
- Use imperative, present-tense wording.
- Do not include explanations, alternatives, bullets, or diagnostics unless the
  user explicitly asks for them.

## Output

After creating the commit, return only the concise commit result.
