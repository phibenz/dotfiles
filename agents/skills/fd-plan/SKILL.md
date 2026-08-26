---
name: fd-plan
description: Plan an overall feature and create either one implementation ticket or a parent plan. After the user confirms a parent plan, create its ordered child tickets. Use when the user asks for a feature design, work breakdown, parent ticket, subtickets, or dependency-aware ticket plan. Do not use for one already-scoped implementation ticket; use fd-ticket.
---

# Plan a Linear Feature

Design the complete feature and divide it into coherent implementation tickets.
For a multi-ticket feature, create the parent plan and wait for explicit user
confirmation before creating child tickets. Linear is the source of truth. Do
not create local feature-design files.

Before creating implementation tickets, read and follow the `fd-ticket` skill.
Use its ticket boundary, description format, Linearis runtime rules, and error
handling for every leaf ticket.

## Argument

Accept a feature title, feature description, or existing Linear issue
identifier in `$ARGUMENTS`.

An existing issue becomes the single implementation ticket or the parent plan,
depending on the final work breakdown.

## Planning Rules

- Plan the complete outcome before dividing the work.
- Make each implementation ticket one coherent semantic change that normally
  maps to one pull request.
- Keep a coherent change together even when it touches several layers or files.
- Split work when parts have independent outcomes, review boundaries,
  ownership, rollout steps, or merge order.
- Do not split work by file or code layer only to make each diff smaller.
- Include required tests, migrations, and documentation with the behavior they
  verify or support.
- Model merge prerequisites as blocking relations.
- Keep non-blocking relationships out of the dependency graph.
- Never create a circular dependency.

## Workflow

### 1. Understand the feature

- Identify the desired user-visible or operational outcome.
- Inspect the current repository, relevant Linear issues, and existing project
  patterns before choosing the design.
- Define the scope, constraints, integration points, and success criteria.
- Resolve material design choices when the codebase supports a clear default.
- Ask only for choices that would materially change the design or ticket graph.

### 2. Build the work graph

For each proposed implementation ticket, define:

- A stable temporary reference such as `T1`.
- The semantic outcome and scope boundary.
- The expected pull request boundary.
- Direct blockers.
- A parallel group based on the dependency graph.
- Focused acceptance criteria.
- Focused verification using checks that pre-commit does not already run.

Tickets in the same parallel group must have no dependency on each other. A
later group can start only after its direct blockers are complete.

### 3. Choose the Linear shape

- Create one implementation ticket when one pull request can deliver the whole
  feature as one coherent semantic change.
- Create one parent plan that proposes multiple child tickets when the feature
  needs two or more implementation tickets.
- Do not create a parent issue that would contain only one child.
- Keep every feature plan as a top-level issue. Do not create a plan as the
  child of another issue.
- When a feature needs a parent plan, create only implementation tickets as its
  direct children.
- If a proposed child needs multiple pull requests, create sibling tickets
  under the same plan.
- Use blocking relations to represent structure between sibling tickets.
- Use a Linear project or initiative to coordinate multiple feature plans.
- Treat the parent as coordination and design context. Do not map it to a pull
  request.
- Do not create child tickets until the user explicitly confirms the parent
  design. The initial planning request is not confirmation.

For a parent plan, use this structure:

```md
## Summary

- <Feature outcome and why it matters.>

## Goal

<The complete outcome this plan must deliver.>

## Scope

- <Included behavior>

## Design

<The overall approach, important boundaries, and integration decisions.>

## Work Breakdown

| Ref | Ticket | Outcome | Blocked by | Parallel group |
|-----|--------|---------|------------|----------------|
| T1 | <title or issue link> | <semantic outcome> | None | 1 |

## Success Criteria

- [ ] <Feature-level observable result>

## Open Questions

- <Only unresolved choices that still need an owner>
```

Use one to three short bullets in `Summary`.

Add `## Out of Scope` after `## Scope` only when the boundary can be ambiguous.
Also add it when prior discussion identifies explicit non-goals or related work
that this plan must exclude. Use a bullet list for the excluded items.

Add `## Integration and Rollout` after `## Work Breakdown` only when the feature
needs staged activation, migration, compatibility sequencing, or a separate
cross-ticket integration step. Do not use it to repeat ticket order,
dependencies, or outcomes from `Work Breakdown`.

Keep implementation details in the child tickets unless they define a
cross-ticket contract.

### 4. Create the plan

Authenticate once and resolve the team, project, and assignee before the first
creation. Use one project for the issue tree unless ownership clearly requires
another project. Ask when ownership is ambiguous.

If the plan has one ticket:

1. Create or update it with the `fd-ticket` contract.
2. Do not create a parent issue.

If the plan has multiple tickets:

1. Create or update the parent plan.
2. Keep temporary references in the proposed `Work Breakdown` table.
3. Report the parent, proposed ticket graph, and parallel groups.
4. Stop and ask the user to confirm the design. Do not create child tickets or
   blocking relations.

If the user requests changes, update the parent plan and stop for confirmation
again.

### 5. Create confirmed child tickets

Continue only after the user explicitly confirms the parent design or asks to
create child tickets from a confirmed parent. Reread the parent before creating
anything so the child tickets use the confirmed design.

1. Create every implementation ticket with `--parent-ticket <parent>`.
2. After all identifiers are known, add each direct dependency with
   `issues update <ticket> --blocked-by <blocker>` or the equivalent relation
   command.
3. Update the parent `Work Breakdown` table with the real issue identifiers and
   URLs.
4. Verify the parent link and blocking relations with Linearis reads.

If creation stops after a partial success, do not delete created issues. Report
the completed issue identifiers, the failed step, and the exact remaining work.

### 6. Report

Before confirmation, report the parent issue, proposed blocking graph, parallel
groups, and the required confirmation. After confirmation, also report all
child ticket identifiers and URLs. State whether the result is a single ticket
or a parent with child tickets. Do not commit repository changes.
