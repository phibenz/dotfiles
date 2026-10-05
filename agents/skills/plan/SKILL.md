---
name: plan
description: Prepare a reviewed feature plan and the next implementation ticket through automatic drafting, review, and revision. Use for requests to plan a feature or automate planning rounds. Stop before coding. Use assess for a standalone read-only assessment.
---

# Prepare the Plan and Next Ticket

Manage drafting and review rounds until the plan and next ticket are ready to present.
Wait for the user's go before coding.
Continue through [build](../build/SKILL.md) after approval. Use [babysit](../babysit/SKILL.md) for PR review follow-up.

## 1. Establish the outcome and current state

- Apply [PR Workspaces](../ticket/references/workspaces.md) before detailed planning. It owns feature isolation and prerequisite handoffs through `fork`.
- Read [Manage Local Planning Files](../ticket/references/drafts.md) and resolve the origin store before writing.
- Read the feature request, canonical plan, and relevant tickets.
- Establish the agreed outcome, scope, compatibility promises, and explicit exclusions.
- Inspect current code, callers, ownership, and verification paths.
- Identify the target base or predecessor branch from repository evidence.
- Distinguish implemented prerequisites from planned prerequisites.
- For a separate prerequisite feature, record the dependency and use `fork` to plan it in its own context. Stop dependent planning readiness until its contract or code is available.
- Resolve technical questions from code or small, isolated experiments when useful.
- Ask only about material product decisions, scope changes, or constraints that evidence cannot settle.
- Experiments must preserve existing work and stay within the request's execution permissions.

## 2. Design and draft the work

- Use [design](../design/SKILL.md) when consequential design choices remain unresolved. Reuse valid prior decisions.
- Trace a caller path through the affected code. If thin modules split one concept,
  consider keeping its behavior together. Preserve boundaries that own distinct
  invariants or external dependencies.
- Use [outline](../outline/SKILL.md) for the complete outcome, shared contracts, and rough ticket sequence.
- Use [ticket](../ticket/SKILL.md) for the next ticket's contract, short rationale, steps, and verification recipes.
- For one ticket, use `ticket` without creating a parent plan.
- Follow the writers' boundary rules. Restructure unimplemented work when evidence supports it.
- Keep future tickets as outlines. Detail only the next ticket against its actual prerequisite code.
- Revise local drafts automatically within the agreed scope.

## 3. Review and revise

- Use [assess](../assess/SKILL.md) as the read-only assessor for the plan, next ticket, and changed shared contracts.
- Give one review pass this combined scope when applicable. Avoid separate assessments that repeat the same checks.
- For significant shared contracts, require [Independent Contract Review](../assess/references/contract-review.md).
- For other work, a separate self-review pass is sufficient. Identify it as self-review.
- Apply accepted findings through the writers after the review returns.
- Resolve code-supported findings without asking the user to choose ordinary implementation details.
- Reject optional preferences with a concrete reason instead of adding scope.
- Request another assessment of changed contracts and affected dependents after material revisions.
- Finish when the plan is coherent and the next ticket is Ready or Mostly Ready with explicit minor assumptions.
- Future tickets without available prerequisite code receive no readiness verdict.
- Stop for a verified blocker, essential missing evidence, or a material user decision.
- If the same unresolved finding returns, reconsider the design premise before another revision.
- If no evidence-backed revision resolves it, report the issue instead of repeating the loop.

## 4. Record the assessment and present it

- Save the returned [review report](../assess/assets/review.md) under `<origin>/docs/work/<feature>/reviews/<local-id>.md`.
- Use the parent ID for a combined assessment, or the ticket ID for a standalone ticket.
- Keep review reports separate from ticket descriptions and link the current report from the local draft metadata.
- Record finding dispositions and minor assumptions there. Preserve earlier findings when refreshing the report.
- Present a short TLDR of the chosen shape, outlined ticket sequence, and reviewed next ticket.
- Link the local drafts. State unresolved decisions or review limitations only when they remain.
- Present the agent handoff using [PR Workspaces](../ticket/references/workspaces.md).
- Wait for the user's go to [build](../build/SKILL.md) in that ticket's dedicated Herdr workspace and worktree.
- Planning creates no commits or PRs. `fork` owns any worktree, branch, workspace, and conversation setup.

## Reconcile changes during implementation

When implementation changes a shared contract, read [Reconcile the Remaining Plan](references/reconcile.md).
Use the same procedure when relevant code or drafts change after their review.
At a ticket boundary, prepare and present the next ticket before coding it.

## Inspiration

- [Pstack Architect](https://github.com/backnotprop/pstack/blob/main/skills/architect/SKILL.md) informs caller-first design and redesign after repeated friction.
- [Pstack Sequence Verifiable Units](https://github.com/backnotprop/pstack/blob/main/skills/principle-sequence-verifiable-units/SKILL.md) informs ticket and commit boundaries.
