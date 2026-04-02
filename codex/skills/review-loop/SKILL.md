---
name: review-loop
description: Run a review loop for either a committed change set or local changes, prefer `/review` only for committed-scope reviews when available, and preserve the same review mode across re-review passes until the findings are clean.
---

# Review Loop

Run a review loop for the current change set.

The goal is to preserve review intent across passes. Keep the review scope
stable, fix only valid issues, and re-review in the same mode until the review
comes back clean.

## Core Model

This skill has only two review modes:

- `committed-scope`: review committed history such as `base...HEAD` or the last
  commit
- `local-change`: review local staged and/or unstaged tracked changes

Do not silently switch between these two modes.

## Default Behavior

- if the current branch is not `main`, default to `committed-scope`
- if the current branch is `main` and there are tracked local edits, default to
  `local-change`
- if the current branch is `main` and there are no tracked local edits, default
  to reviewing the last commit in `committed-scope`

## Accepted Inputs

Examples:

- `review against main`
- `review the last commit`
- `review the staged changes`
- `review local changes`

Keep the supported surface small on purpose. If the user asks for something
more custom or ambiguous, ask them which of the two modes they want.

Untracked files are out of scope unless the user explicitly asks to include
them.

## Step 1: Determine The Review Mode

1. Decide whether the request is `committed-scope` or `local-change`.
2. If the user explicitly asked for staged changes or local changes, use
   `local-change`.
3. If the user explicitly asked for review against a base branch or for the
   last commit, use `committed-scope`.
4. Otherwise apply the default behavior above.

Return: review mode, review target, objective, and expected review surface.

## Step 2: Build The Review Surface

### Committed-Scope

Use one of these:

- branch review: `git diff <merge-base>...HEAD`
- last commit: `git diff HEAD~1 HEAD`, or if `HEAD` is the root commit, diff
  against the empty tree instead

For non-`main` branches, choose the base branch in this order:

1. PR metadata or another branch-specific signal that identifies the intended
   target branch
2. the remote default branch, such as `origin/HEAD`
3. `origin/main`
4. `origin/master`
5. `main`
6. `master`

If no reasonable base branch can be determined, ask the user.

Do not use the feature branch's own remote tracking branch as the committed
review base when it points back to the current branch, because that only shows
unpushed commits rather than the full diff against the intended target branch.

### Local-Change

Use one of these:

- staged-only review: `git diff --cached`
- full local tracked changes: combine `git diff --cached` and `git diff`

Do not include untracked files unless the user explicitly asked for them.

If the chosen review surface is empty, report that it is empty. Do not replace
it with another scope automatically.

## Step 3: Run The Review

Prefer the built-in `/review` flow only for `committed-scope` reviews when the
environment can invoke it and the requested scope matches what `/review` can
actually review.

Do not prefer `/review` for `local-change` reviews unless the environment can
constrain `/review` to that exact local scope.

When subagents are available:

1. Spawn one review subagent for the current loop
2. Store and reuse its `agent_id` for later re-review passes
3. Give it the exact review mode, diff command or commands, reviewed file set,
   and objective
4. Wait for its result before triaging findings
5. Close the subagent when the loop is complete

Use a strict review prompt:

- ask for prioritized, actionable findings only
- emphasize correctness, regressions, missing validation, and workflow
  reliability
- require file references with line numbers where possible
- say `No findings.` exactly if there are none

If neither `/review` nor a subagent is available, perform the review manually
in the main agent against the same explicit review surface.

## Step 4: Triage Findings

Classify each finding:

- `fix-now`
- `document-now`
- `follow-up`
- `reject`

Rules:

- keep the actual objective in mind
- prefer root-cause fixes over symptom patches
- do not broaden scope casually
- if a finding is likely to reappear, document the intent clearly

## Step 5: Re-Review

After making any `fix-now` changes:

1. Keep the same review mode
2. Keep the same reviewed file set unless the user explicitly expands scope
3. Re-review in the same mode:
   - if original mode was `committed-scope`, review the original committed
     scope plus tracked local fixes to those same reviewed files
   - if original mode was `local-change`, review the same local-change surface
     again
4. For committed-scope re-review, include both:
   - original committed diff for the reviewed files
   - `git diff --cached -- <reviewed-files>` for staged tracked fixes
   - `git diff -- <reviewed-files>` for unstaged tracked fixes
5. For local-change re-review, do not silently switch into committed-scope
6. Wait for the next result from the same review subagent when possible
7. Repeat until the review comes back clean

Do not stage files or hunks just to keep the loop moving. Preserve scope first.

## Output

Return a concise summary with:

- objective of the change
- review mode
- review target and base branch when relevant
- reviewed file set
- whether review ran via `/review`, a review subagent, or the main agent
- findings grouped by `fix-now`, `document-now`, `follow-up`, and `reject`
- code changes or comments added in response
- any residual risks or deferred items

## Working Directory

Use the current working directory as project root.
