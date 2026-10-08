# Reconcile the Remaining Plan

Update and review planning assumptions when implementation changes their basis.
Routine design revisions stay within the already authorized outcome and scope.

## Trace the change

- Compare the implementation with the reviewed ticket's shared contracts.
- Identify which names, inputs, outputs, ownership rules, or behaviors changed.
- Trace remaining steps and tickets that depend on those contracts, including indirect dependents.
- Mark affected readiness verdicts stale before using those tickets for implementation.
- Reassess only assumptions affected by the change.
- Expected implementation progress does not require replanning when the reviewed contracts remain unchanged.
- Preserve completed work and unrelated draft content.

## Revise and review

- If the change requires a separate prerequisite feature, use [fork](../../fork/SKILL.md) for its planning and implementation context.
- Record links between canonical feature drafts. Do not expand the source PR to implement that prerequisite.
- After prerequisite work finishes, inspect its actual code and base before revising affected assumptions or restoring readiness.
- Verify that the prerequisite exists in the assessed implementation checkout. Success in another worktree alone does not restore readiness.
- Use `outline` and `ticket` to revise affected canonical origin drafts and plan boundaries.
- Read current shared drafts before writing. Coordinate changes with other agents that own affected tickets.
- Keep future tickets as outlines. Split, combine, reorder, or replace unimplemented work when the changed contract requires it.
- Preserve assigned IDs and record replacements through the shared local draft rules.
- Use `assess` for one assessment of the revised boundaries, changed contracts, and affected remaining work.
- For significant shared contracts, require [Independent Contract Review](../../assess/references/contract-review.md) before coding affected work.
- Apply accepted findings and review the revisions again.
- Assess the next work against the actual prerequisite code within that review.
- Within a ticket, reassess the remaining steps rather than reopening completed steps.
- Save the returned report through `plan` only after reassessment.
- Later outlines can remain consistent without receiving readiness verdicts.

## Continue or return to the user

- If the outcome and scope remain unchanged, complete the revisions and review automatically.
- Mention the planning impact briefly at the current code review checkpoint.
- Preserve the user's approval checkpoint before committing the current code step.
- Wait for a user decision if the revision changes the outcome, scope, or compatibility promises.
- Report a blocker or missing evidence before coding affected work.
- At a ticket boundary, present the reviewed next ticket, its proposed branch, and its assigned workspace.
- Wait for the user's go in that implementation context.
