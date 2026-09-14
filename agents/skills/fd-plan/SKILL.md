---
name: fd-plan
description: Draft an overall feature objective and implementation boundaries, then divide the work into a linear sequence of tickets for stacked PRs. Use for feature plans and multi-ticket work. Use fd-ticket for one implementation ticket.
---

# Plan a Feature

Outline the complete outcome and the boundaries of each ticket in a linear PR
stack. Keep detailed implementation planning in `fd-ticket`.

Read and follow `fd-ticket` for ticket sizing, code grounding, local drafts,
approval, publication, and error handling. Apply its operational rules to the
parent plan too; use the plan format below instead of the ticket template.

## 1. Define the objective and boundaries

- Inspect the relevant repository code and existing issue context.
- State the overall objective and the boundaries between implementation tickets.
- Record shared contracts or rollout constraints only when they affect those boundaries.
- If one ticket is sufficient, use `fd-ticket` without a parent plan.
- For multiple tickets, use one top-level parent with implementation tickets as
  direct children. The parent describes the feature, not a separate PR.

## 2. Order the stacked PRs

- Use one linear sequence: `T1 → T2 → T3`. Each ticket represents one PR;
  its implementation steps represent commits within that PR.
- Base the first PR on the target branch and each later PR on its predecessor.
  Order prerequisites first and define each ticket's incremental change.
- Assess each ticket's size against the preceding branch, not the cumulative stack.
- Implement in sequence; later work can build on an earlier branch before it
  merges. Review and merge the stack from the first PR upward.
- Keep each ticket coherent and testable with the preceding changes present.
  Record external blockers separately from the stack order.

## 3. Draft and review locally

- Read and use [assets/plan.md](assets/plan.md). Keep the parent concise:
  objective, implementation boundaries, and a rough ordered ticket list.
- Use the `fd-ticket` filename rules. `P1` and `T1`, `T2`, and so on are temporary
  IDs until Linear assigns real IDs: `P` stands for plan and `T` stands for ticket.
- Start with the rough plan. As work progresses, refine the next child through
  `fd-ticket`; later children remain outlines in the parent until needed.
- Keep detailed tests, code locations, sketches, and commit-sized steps in that
  child's local draft. Revise the remaining plan using what earlier work reveals.
- Share the plan or current child draft for review before requesting publication approval.

## 4. Publish incrementally

- Use `fd-ticket` for runtime checks, approved content, metadata preservation,
  update-note handling, and recovery from partial publication.
- Publish the parent when approved. Then publish child tickets one at a time
  as their drafts are refined and approved. Plan approval covers only the plan;
  batch publication requires explicit approval of the specified child drafts.
- Link each published child to the parent. Represent its predecessor as a
  blocking relation for merge
  order; this does not require waiting for a merge before starting implementation.
- Replace temporary references with issue links in the parent and local drafts.
  Verify parent links and blocking relations along with published content.
- Report published IDs, URLs, and any drafts still awaiting approval.
- Planning does not create branches, commits, or PRs.
