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
- Declare the mode: **check** for one read-only status and triage pass; **address** for existing findings; **watch** for continued monitoring.
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
- Reuse a disposition only when the claim, relevant code, replies, and assumptions remain unchanged.
- Keep a local record of source IDs, assessed revisions, dispositions, evidence, and pending actions under the canonical feature's `reviews/pr-<number>.md`.
- If the PR has no local ticket, keep the record in the conversation. Do not invent a feature or copy planning into the worktree.
- Keep remote thread state separate from local disposition. An invalid claim can still need a reviewer response.
- Keep local-only corrections separate from published fixes. Do not repeat an existing correction while its commit awaits publication.
- For failed checks, inspect logs and classify code failure, missing prerequisite, or verification environment failure.
- Correct a confirmed code failure within the PR's scope. Report unrelated failures and unavailable evidence without claiming a pass.
- Rerunning remote checks requires authorization. Do not repeatedly retry a failure or alter checks to obtain a green result.

## 3. Prepare supported corrections

- In `check`, return findings without editing code or drafts.
- In `address` and `watch`, collect known valid findings before selecting one coherent correction step. Group related claims; split independent fixes into separate steps.
- A claim owned by another feature or already merged code needs a separate handoff. Do not hide that work in the current PR.
- Draft concise reviewer replies with the finding disposition and evidence, including supported reasons for rejecting invalid claims.
- Give [build](../build/SKILL.md) the triaged claims, canonical ticket or agreed PR contract, reply drafts, and recorded delivery scope.
- `build` owns implementation, design reconciliation, verification, elegance, the combined code-and-replies checkpoint, and the approved commit.
- For reply-only work, present the drafts without invoking `build` or creating a commit.
- At the checkpoint, request any missing delivery authorization with the concrete drafts and proposed actions. Keep it with code review at one checkpoint.
- Honor the scope of the user's response. Code approval alone permits the commit; a request covering replies also permits those replies.
- After the approved commit, perform only the authorized delivery actions. Reuse standing authorization without asking again; never skip the next commit checkpoint.
- If an approved correction already has a commit, publish it when authorized without creating another commit or changing stack topology.
- For an authorized remote reply, use a structured payload or body file. Re-read the thread and current head before posting; inspect remote state after an uncertain result.
- Describe a fix as published only when its commit is present in the remote PR. Resolve an authorized thread only when evidence supports its disposition.

## 4. Continue or return the checkpoint

- `check` ends after its report. `address` ends at the correction checkpoint or after requested corrections complete.
- In `watch`, refresh reviews, replies, head, and checks after a push or meaningful state change. Retriage affected claims when their basis changes.
- While waiting for remote changes, use one polling loop with waits of at most 60 seconds. Respect API rate limits and keep the user informed.
- A checks watcher alone does not monitor new reviews. Refresh the full evidence snapshot during every polling cycle.
- Return control at a correction checkpoint, required user decision, verified blocker, execution limit, or user stop request. State what remains pending.
- If a required push, reply, or thread resolution lacks authorization, present the concrete commit or response draft and return control.
- Stop when the PR is closed or merged. Report that external change; babysitting does not authorize merging it.
- Report **merge-ready** only when the current remote head has passing required checks, required approvals, no unresolved review threads, and a GitHub merge state consistent with repository rules.
- Green checks alone do not establish readiness. Unknown mergeability, incomplete evidence, or unpublished fixes prevent that verdict.
- A requested review that has not finished also prevents that verdict. Do not treat absence of findings as a completed review.
- Stop `watch` at merge-ready. If the environment cannot keep the loop running, report monitoring as stopped; do not imply background work continues.

## Inspiration

[Pstack's Babysit playbook](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/babysit.md) informs review triage and PR monitoring.
This workflow uses the existing user checkpoint, local planning store, and dedicated PR workspace.
