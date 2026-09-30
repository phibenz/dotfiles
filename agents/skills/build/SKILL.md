---
name: build
description: Implement code in small steps with automatic verification and elegance review. Wait for the user's review before committing each step. Use for requests to build a feature or implement a ticket with review and approval at each step.
---

# Code One Step at a Time

Complete each step through verification and elegance review before presenting it.
The user reviews the diff in a separate viewer. Each approved step becomes one commit.
Use [plan](../plan/SKILL.md) before coding a new feature and [babysit](../babysit/SKILL.md) for PR review follow-up.

## 1. Select and explain the step

- Read the canonical ticket or agreed task. Require scoped implementation authorization; an explicit implementation request supplies it.
- For a ticket prepared through `plan`, require the user's go after its planning checkpoint.
- Apply [PR Workspaces](../ticket/references/workspaces.md) before editing. It owns context verification, prerequisite isolation, and ticket handoffs.
- Compare reviewed drafts and relevant code with the current state. If their assumptions changed, [reconcile affected work](../plan/references/reconcile.md) before coding it.
- Select the next coherent commit through [Define Ticket and Step Boundaries](../ticket/references/boundaries.md). Include needed code, tests, and documentation.
- Update revised steps before coding. For work without a ticket, record the agreed step and recipe in the conversation.
- Give a short TLDR of the purpose and approach. Mention tradeoffs only when they affect the user's decision.
- Continue without another approval of this summary. Ask first only when an unresolved decision materially affects behavior, scope, or design.

## 2. Implement, verify, and review

- Implement the step within its agreed scope. Use `tdd` when writing or reviewing tests.
- Use [verify](../verify/SKILL.md) to run the recipe and return evidence. Revise insufficient recipes and reassess affected assumptions.
- Correct verification failures within scope, then verify again.
- Apply `elegance` to the step's diff. Correct material findings automatically and verify affected behavior again.
- For unresolved consequential choices, use [design](../design/SKILL.md) and obtain the required contract assessment.
- When a shared contract changes, reconcile affected steps and tickets, including required independent assessment.
- Update the task's rationale and verification recipe when the chosen shape changes. Use the canonical ticket when one exists.
- Continue until the step is ready or a concrete blocker prevents completion. Report missing evidence or decisions and blocked or unrun checks accurately.

## 3. Present the review checkpoint

- Give a short TLDR of the result and verification. Mention material departures, remaining limitations, or planning changes when present.
- Include caller-provided reviewer reply drafts and recorded delivery scope at the same checkpoint. Update the drafts to match verified evidence.
- Present concrete delivery actions that still need authorization. Code approval alone does not authorize remote actions; reuse explicit authorization for this PR.
- Do not paste the diff or repeat the ticket, review findings, or principle checklist. Let the code communicate the design.
- Answer questions and discuss alternatives when requested. Apply requested corrections within scope, then verify and review changed parts before presenting them again.
- Wait for explicit approval before committing or starting another step. Questions and correction requests are discussion, not approval.

## 4. Commit and continue

- Apply [Commit the Approved Step](references/commit.md) for approval freshness, isolation, attribution, and hook handling.
- When the explicit request or recorded PR delivery scope includes pushing, use `acp` for one commit and push.
- Otherwise create one local commit. Pushes and PR publication require explicit authorization.
- Preserve ACP's push rules and retry limit when using its route.
- Report the commit hash and subject briefly.
- For a `babysit` correction, return the commit and verification evidence to `babysit` for authorized delivery and the next correction.
- Otherwise continue requested steps in the same ticket after the commit, with the same checkpoint before each subsequent commit.
- At a requested ticket boundary, use `plan` to prepare and present the next ticket. Follow its separate workspace handoff and wait for the user's go there.
