# Define Ticket and Step Boundaries

## Derive tickets and steps

- One ticket delivers one coherent outcome through one PR.
- One step delivers one behavior or design decision that the user can review and verify before committing.
- Include the production changes, tests, and documentation needed to complete that step.
- Split independently useful outcomes into separate tickets.
- Split steps when each resulting change remains understandable and verifiable on its own.
- Combine steps when separating them leaves an incomplete contract or requires temporary scaffolding without a concrete need.
- Keep future tickets as outlines. Refine the next ticket against actual prerequisite code.
- Treat boundaries as design decisions. Reassess them when implementation provides new evidence.
- Split, combine, reorder, or replace unimplemented work when this improves correctness or reviewability.
- Preserve assigned IDs and record replacements in the plan using [Manage Local Planning Files](drafts.md).
- Preserve approved commits. Revising future work does not authorize rewriting completed work.
