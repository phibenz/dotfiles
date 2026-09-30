---
name: outline
description: Draft a feature outline with implementation boundaries and a rough sequence of tickets for stacked PRs. Use for requests to outline a feature or restructure ticket boundaries. Use plan for automated planning and review rounds, or ticket for one implementation ticket.
---

# Outline a Feature

Outline the complete outcome and the boundaries of each ticket in a linear PR
stack. Keep detailed implementation planning in `ticket`.

Read [Manage Local Planning Files](../ticket/references/drafts.md) for origin storage, feature folders, IDs, and revisions.
Apply [PR Workspaces](../ticket/references/workspaces.md) before detailed planning for a new feature.
Read [Define Ticket and Step Boundaries](../ticket/references/boundaries.md) for work boundaries.
Use [design](../design/SKILL.md) for unresolved consequential choices. Reuse valid prior decisions.
Use `ticket` only when refining an implementation ticket.

## 1. Define the objective and boundaries

- Inspect the relevant repository code and existing local planning context.
- State the overall objective and the boundaries between implementation tickets.
- Record shared contracts or rollout constraints only when they affect those boundaries.
- If one ticket is sufficient, use `ticket` without a parent plan.
- For multiple tickets, use one top-level parent with implementation tickets as
  direct children. The parent describes the feature, not a separate PR.

## 2. Order the stacked PRs

- Use one linear sequence: `T3.1 → T3.2 → T3.3` for plan `P3`.
  Each ticket represents one PR;
  its implementation steps represent commits within that PR.
- Base the first PR on the target branch and each later PR on its predecessor.
  Order prerequisites first and define each ticket's incremental change.
- Assess each ticket's size against the preceding branch, not the cumulative stack.
- Implement in sequence; later work can build on an earlier branch before it
  merges. Review and merge the stack from the first PR upward.
- Keep each ticket coherent and testable with the preceding changes present.
  Record external blockers separately from the stack order.

## 3. Draft locally

- Read and use [assets/plan.md](assets/plan.md). Keep the parent concise:
  objective, implementation boundaries, and a rough ordered ticket list.
- Store the parent as `<origin>/docs/work/<feature>/plan.md` using the shared storage rules.
- Treat supplied paths as input and preserve their source files. Never create a copy in the PR worktree.
- Use the shared local ID and filename rules. Choose the next increasing
  feature number for the plan. Assign child IDs in its ticket list. For example,
  plan `P3` lists `T3.1` and `T3.2`.
- Reuse each child's ID when refining its draft. Assign a new child ID only
  when adding a child to the plan.
- Start with the rough plan. As work progresses, refine the next child through
  `ticket`; later children remain outlines in the parent until needed.
- Keep contracts, code locations, commit steps, and verification in that child's
  local draft. Revise the remaining plan using what earlier work reveals.
- Use `assess` for a read-only assessment when requested. Use `plan` to automate drafting and review rounds.

## 4. Present the local outline

- Report the canonical plan path, rough ticket sequence, and next ticket to refine.
- Keep parent, predecessor, and prerequisite relations in the canonical local drafts.
- Present future tickets as outlines. Use `plan` for the reviewed planning checkpoint.
- Planning creates no commits or PRs. Use `fork` for required feature isolation.
