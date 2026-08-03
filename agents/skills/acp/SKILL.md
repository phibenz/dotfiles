---
name: acp
description: Stage only the intended current changes, create exactly one concise conventional commit with active-model co-author attribution, and push it. Set up the remote tracking branch when the current branch has no upstream. Use when the user invokes $acp, says acp, says add commit push or stage commit push, or asks to commit and push current changes.
---

# Add, Commit, Push

Stage the complete intended change, commit it once, and push the current branch.

## Workflow

1. Verify the repository and inspect its state:
   - `git rev-parse --is-inside-work-tree`
   - `git branch --show-current`
   - `git status --short --untracked-files=all`
   - Stop on a detached HEAD and ask the user which branch should receive the commit.
2. Choose the complete commit scope using the Scope Rules below.
3. Inspect relevant unstaged changes just enough to confirm scope, then stage
   explicit pathspecs with `git add -- <pathspecs>`.
4. Inspect the final staged diff:
   - `git diff --cached --no-ext-diff`
   - If it is empty, stop and say `no changes to commit`. Do not create an empty
     commit or push unrelated existing commits.
5. Write one concise conventional commit subject and active-model attribution:
   - `Co-authored-by: <model> <noreply@openai.com>`
   - Use the active model display name plus reasoning effort when known, such as
     `GPT-5.5 medium`. Otherwise use the active model display name.
6. Run exactly one commit command with two message arguments:
   - `git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>"`
   - Escape shell-sensitive characters in both arguments.
   - Forward user-provided commit flags such as `--amend` or `--no-verify`.
7. Push only after the commit succeeds:
   - If `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'`
     succeeds, run `git push` with any explicitly requested safe push flags.
   - If there is no upstream, choose the remote in this order: the branch's
     configured remote, `origin`, or the sole configured remote.
   - When a remote is unambiguous, run
     `git push --set-upstream <remote> HEAD` to create or connect the remote
     branch and push the commit.
   - If there is no remote, or multiple remotes with no unambiguous choice, stop
     after the commit and ask the user which remote to use.
8. Verify the final branch and upstream state with `git status --short --branch`.

## Scope Rules

- Infer scope from the user request, conversation, staged files, and dirty state.
- Treat staged files as evidence, not as a hard boundary. Include relevant
  unstaged files from the same intended change.
- Stage explicit pathspecs only. Never use `git add .` or a broad directory
  unless the user clearly requested that whole directory.
- Leave unrelated, older, local, generated, editor, and separate documentation
  changes untouched.
- If multiple coherent change groups remain or scope is unclear, ask which files
  belong in the commit.

## Commit Message

- Use a conventional prefix such as `feat:`, `fix:`, `docs:`, `test:`,
  `refactor:`, `build:`, `ci:`, `chore:`, or `revert:`.
- Choose the prefix from the staged diff.
- Keep the subject to one line and preferably under 72 characters.
- Use imperative, present-tense wording.

## Push Safety

- Never force-push unless the user explicitly requests it. Prefer
  `--force-with-lease` over `--force` when a force push is authorized.
- Do not pull, merge, rebase, amend, or retry with force after a rejection unless
  the user authorizes that recovery.
- Treat authentication, signing, hook, network, and remote rejection failures as
  real failures. Preserve their output and do not bypass configured safeguards.
- If the commit succeeds but the push fails, report the created commit and the
  push failure clearly so the user knows the local mutation completed.

## Output

After a successful push, report only the concise commit result and pushed branch
or upstream. Do not add a separate narrative. If the push fails after the commit,
report the commit result followed by the concise push failure.
