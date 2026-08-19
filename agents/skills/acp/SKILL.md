---
name: acp
description: Delegate staging, committing, and pushing only the intended current changes to a background subagent. Create exactly one concise conventional commit with active-model co-author attribution, and ensure the current branch tracks its same-name remote branch. Use when the user invokes $acp, says acp, says add commit push or stage commit push, or asks to commit and push current changes.
---

# Add, Commit, Push

Stage the complete intended change, commit it once, and push the current branch.

## Delegation and Sequencing

When you are the parent agent, delegate the complete workflow to exactly one background subagent:

1. If the user also requests `$pr`, treat ACP as the first serial stage. Do not spawn the PR worker yet.
2. Spawn the ACP worker with `task_name = "acp_worker"`, `fork_turns = "none"`, `model = "gpt-5.6-terra"`, and `reasoning_effort = "low"`.
3. Include the user's request, the current working directory, this skill's absolute path, the intended file scope, and requested commit flags. Tell the worker to read the skill, skip this section, execute the Workflow directly, and never spawn another subagent.
4. Do not duplicate its Git mutations. Surface approval requests and wait for its result.
5. If ACP succeeds and the user requested `$pr`, start the PR skill next. If ACP fails, stop and do not create or update a PR.

When you are the delegated worker, skip this section and execute the Workflow directly.

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
6. Run the initial commit attempt with two message arguments:
   - `git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>"`
   - Escape shell-sensitive characters in both arguments.
   - Forward user-provided commit flags such as `--amend` or `--no-verify`.
   - If it fails, apply the Hook Repair and Retry rules below. Do not retry for
     any other failure.
7. Push only after the commit succeeds:
   - Inspect `branch.<current-branch>.remote` and
     `branch.<current-branch>.merge`. Treat the upstream as correct only when
     the remote exists and the merge ref equals
     `refs/heads/<current-branch>`.
   - If the upstream is correct, run `git push` with any explicitly requested
     safe push flags.
   - If the upstream is absent or points to a different branch, choose the
     remote in this order: the branch's configured push remote,
     `remote.pushDefault`, the branch's configured remote, `origin`, or the sole
     configured remote. Ignore `.` as a push target.
   - When a remote is unambiguous, run
     `git push --set-upstream <remote> HEAD:refs/heads/<current-branch>` to
     create or connect the same-name remote branch and push the commit. This
     also replaces an inherited upstream such as `origin/main`.
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
  again, and rerun the identical commit command once.
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
