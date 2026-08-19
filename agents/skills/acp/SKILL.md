---
name: acp
description: Stage, commit, and push only the intended current changes through a fast inline workflow, with optional background delegation. Create exactly one concise conventional commit with active-model co-author attribution, and ensure the current branch tracks its same-name remote branch. Use when the user invokes $acp, says acp, says add commit push or stage commit push, or asks to commit and push current changes.
---

# Add, Commit, Push

Stage the complete intended change, commit it once, and push the current branch.

## Execution and Sequencing

When you are the parent agent:

1. Execute the Workflow directly by default.
2. If the user explicitly requests background or delegated ACP, spawn exactly
   one worker with `task_name = "acp_worker"`, `fork_turns = "none"`,
   `model = "gpt-5.6-terra"`, and `reasoning_effort = "low"`.
3. Give the worker the user request, working directory, this skill's absolute
   path, intended file scope, and requested flags. Tell it to skip this section,
   execute the Workflow, and never spawn another subagent. Do not duplicate its
   mutations; wait for its result.
4. For a combined `$acp` and `$pr` request, complete ACP first using the selected
   execution mode. Invoke the PR skill only after ACP pushes successfully. Stop
   without creating or updating a PR if ACP fails.

When you are the delegated worker, skip this section and execute the Workflow directly.

## Workflow

1. Infer the likely intended paths from the user request and conversation. Batch
   the initial read-only inspection into one tool call:
   - Run `git status --short --branch --untracked-files=all`. This verifies the
     repository and identifies the current branch. Stop on a detached HEAD.
   - Inspect the staged and unstaged diffs for the likely intended paths. Widen
     the inspection only when the scope remains unclear.
   - Run `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'` and
     `git remote`. Treat a missing upstream as expected, not as an inspection
     failure.
2. Choose the complete commit scope using the Scope Rules below.
3. In one tool call, stage explicit pathspecs with
   `git add -- <pathspecs>` and then inspect
   `git diff --cached --no-ext-diff`. Stop if the cached diff is empty or
   contains changes outside the intended scope.
4. Write one concise conventional commit subject and active-model attribution:
   - `Co-authored-by: <model> <noreply@openai.com>`
   - Use the active model display name plus reasoning effort when known, such as
     `GPT-5.5 medium`. Otherwise use the active model display name.
5. Choose the push command using the Push Target rules below. In one tool call,
   run the commit and then the push with `&&`, so a failed commit cannot push:
   - `git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>" && <push-command>`
   - Escape shell-sensitive characters in both arguments.
   - Forward user-provided commit flags such as `--amend` or `--no-verify`.
   - If the commit portion fails, apply the Hook Repair and Retry rules below.
     If the push portion fails after a successful commit, report that partial
     result and do not retry.

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

## Push Target

- Use `git push` when the initial inspection shows an existing remote upstream
  whose branch name exactly matches the current local branch.
- Only when the upstream is absent or mismatched, inspect the branch's push
  remote, `remote.pushDefault`, configured remote, `origin`, and sole remote in
  that order. Ignore `.` as a push target.
- When the fallback remote is unambiguous, use
  `git push --set-upstream <remote> HEAD:refs/heads/<current-branch>`. If it is
  ambiguous, stop before committing and ask the user which remote to use.

## Hook Repair and Retry

- Allow one repair-and-retry cycle only when no commit was created and a Ruff,
  `ruff-format`, or Ty hook failed.
- Determine whether each diagnostic was caused by the intended diff. Inspect
  the staged and unstaged diffs, diagnostic locations, and changed contracts or
  callers. Treat uncertain causality as unrelated.
- Keep `ruff-format` output only when every affected path belongs to the
  intended scope and the hook changes are formatting-only.
- Fix a Ruff or Ty diagnostic only when the intended changes caused it. Make
  the smallest correction in intended paths or directly affected dependent
  paths. Never run a broad fix across the repository.
- Leave pre-existing and unrelated failures unchanged. If one blocks the hook,
  stop and report it instead of expanding the commit scope.
- Stage only the repaired intended paths, inspect the complete cached diff
  again, and rerun the same combined commit-and-push command once.
- Stop when another hook type failed, the second commit attempt fails, or the
  repair would mix with unrelated local changes.
- Never bypass the hooks or add `--no-verify` unless the user requested it.

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
