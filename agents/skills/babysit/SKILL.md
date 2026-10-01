---
name: babysit
description: Monitor a GitHub PR's reviews and checks, validate findings, and prepare focused fixes for the user's review checkpoint. Use for babysit this PR, watch reviews, address review comments, or get this PR ready. A status-only request gets one read-only pass. Commits require step approval; pushes and remote replies require explicit authorization. Opening a PR does not start monitoring.
---

# Babysit a Pull Request

Collect current PR evidence, validate findings through `triage`, and prepare supported corrections through `build`.
Keep the user's review checkpoint before each commit.

## 1. Select the PR and mode

- Resolve the exact repository, PR, head branch, base, and remote head commit. Do not guess from a branch name alone.
- Identify expected checks and reviewers from repository rules and the request. Distinguish completed reviews from reviews that have not run yet.
- Declare the mode: **check** for one read-only status and triage pass; **address** for existing findings; **watch** until the user stops monitoring.
- Use `check` for status-only requests, `address` for requests to address comments, and `watch` for requests to babysit or watch a PR.
- `address` and `watch` authorize preparing valid corrections within the assigned PR's existing outcome. They do not authorize commits or publication.
- Record explicit delivery authorization once for this repository and PR: pushes, replies, thread resolution, or remote check reruns.
- Reuse that scope across rounds until the user changes it. Do not infer it from babysitting, another PR, or code approval alone.
- Verify the PR's dedicated worktree and Herdr workspace using [PR Workspaces](../ticket/references/workspaces.md) before implementation.
- Match repository identity, branch, local HEAD, and existing dirt to the remote PR. Preserve local approved commits; distinguish unpushed work from stale code.
- If another agent owns implementation or monitoring for this PR, coordinate before editing. Do not run competing fix loops.
- Keep each fix in the owning PR's context. Read other PRs as evidence; return their findings to their owner.
- Do not switch branches, rebase, retarget, force-push, merge, enable auto-merge, or change stack topology during babysitting.

## 2. Collect and triage

- Follow [Collect PR Evidence](references/github.md). Record the remote head and collection time with the snapshot.
- Report merge conflicts or missing prerequisites before preparing dependent fixes. A conflict does not authorize a rebase.
- Use [triage](../triage/SKILL.md) for new or materially changed review claims. Include claims in review bodies and general discussion.
- When several independent review comments or PR issues exist, use read-only subagents for parallel analysis when available. Give each worker one issue or related comment group, source links, the current PR head, and the agreed contract.
- Ask comment workers to apply `triage`. Ask check-failure workers to inspect logs.
- Each worker returns evidence, a disposition or failure class, the smallest proposed correction, an optional unapplied diff, and a verification idea. For comments, include a draft reply.
- Start subagents with read-only permissions when available. They may inspect code and run safe checks, but must not edit the shared checkout, commit, push, post replies, resolve threads, or change PR state.
- Validate their findings against the current head. Resolve duplicate or conflicting proposals before giving supported corrections to `build`; a worker's conclusion is not a verified result.
- Reuse a disposition only when the claim, relevant code, replies, and assumptions remain unchanged.
- Keep a local record of source IDs, assessed revisions, dispositions, evidence, and pending actions under the canonical feature's `reviews/pr-<number>.md`.
- If the PR has no local ticket, keep the record in the conversation. Do not invent a feature or copy planning into the worktree.
- Keep remote thread state separate from local disposition. An invalid claim can still need a reviewer response.
- Record whether each review thread starts with a human or bot comment. Treat uncertain authorship as human.
- Keep local-only corrections separate from published fixes. Do not repeat an existing correction while its commit awaits publication.
- For failed checks, inspect logs and classify code failure, missing prerequisite, or verification environment failure.
- Correct a confirmed code failure within the PR's scope. Report unrelated failures and unavailable evidence without claiming a pass.
- Rerunning remote checks requires authorization. Do not repeatedly retry a failure or alter checks to obtain a green result.

## 3. Prepare supported corrections

- In `check`, return findings without editing code or drafts.
- In `address` and `watch`, collect known valid findings before selecting one coherent correction step. Group related claims; split independent fixes into separate steps.
- A claim owned by another feature or already merged code needs a separate handoff. Do not hide that work in the current PR.
- Draft concise reviewer replies with the finding disposition and evidence, including supported reasons for rejecting invalid claims.
- Prefix each AI-written review reply with the active model ID in brackets, such as `[gpt-6.1-sol]`. Use `[AI]` if the exact model ID is unavailable.
- For each review comment addressed by a correction, prepare a response linked to its source ID. After verification, state what changed and the verification result or limit.
- At the checkpoint, give the user a concise status for every collected issue and its proposed response. Mark issues that remain pending or need a decision.
- Give [build](../build/SKILL.md) the triaged claims, canonical ticket or agreed PR contract, reply drafts, and recorded delivery scope.
- `build` owns implementation, design reconciliation, verification, elegance, the combined code-and-replies checkpoint, and the approved commit.
- For reply-only work, present the drafts without invoking `build` or creating a commit.
- At each checkpoint, show any reviewed change, reply drafts, and proposed delivery actions. End with: "Reply `y` to approve these actions and continue babysitting."
- A bare `y` approves one presented commit and only the delivery actions listed at that checkpoint. It does not authorize later commits or unlisted remote actions.
- If the user requests changes or asks a question, resolve it and present the revised checkpoint. Do not treat that response as approval.
- After the approved commit, perform only the authorized delivery actions. Reuse standing authorization without asking again; never skip the next commit checkpoint.
- If an approved correction already has a commit, publish it when authorized without creating another commit or changing stack topology.
- Before replying about a code correction, verify its commit is present in the remote PR. If the push is pending or fails, keep the reply draft pending.
- For an authorized remote reply, use a structured payload or body file. Re-read the thread and current head before posting; inspect remote state after an uncertain result.
- Describe a fix as published only when its commit is present in the remote PR.
- Never resolve a thread started by a human reviewer, even after addressing it. Leave that decision to the reviewer.
- Resolve a bot review thread only when authorization and evidence support its disposition.

## 4. Continue or return the checkpoint

- `check` ends after its report. `address` pauses at a correction checkpoint and ends after requested corrections complete.
- In `watch`, refresh reviews, replies, head, and checks after a push or meaningful state change. Retriage affected claims when their basis changes.
- While waiting for remote changes, use one polling loop with waits of at most 60 seconds. Respect API rate limits and keep the user informed.
- A checks watcher alone does not monitor new reviews. Refresh the full evidence snapshot during every polling cycle.
- Pause at a correction checkpoint for `y`, then continue the same mode. Do not treat the checkpoint as the end of babysitting.
- If a required push, reply, or eligible bot thread resolution lacks authorization, list that action at the checkpoint for the user's `y`.
- Report a verified blocker or required user decision and keep watching for changes that may resolve it.
- If the PR closes or merges, report that terminal state. Do not claim live monitoring after the PR is terminal; babysitting does not authorize merging it.
- Report **merge-ready** only when the current remote head has passing required checks, required approvals, no unresolved review threads, and a GitHub merge state consistent with repository rules.
- Green checks alone do not establish readiness. Unknown mergeability, incomplete evidence, or unpublished fixes prevent that verdict.
- A requested review that has not finished also prevents that verdict. Do not treat absence of findings as a completed review.
- Report merge-ready when reached, then keep watching until the user says to stop. If the environment cannot keep the loop running, report monitoring as interrupted; do not imply background work continues.

## Inspiration

[Pstack's Babysit playbook](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/babysit.md) informs review triage and PR monitoring.
This workflow uses the existing user checkpoint, local planning store, and dedicated PR workspace.
