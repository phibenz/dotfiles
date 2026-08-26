---
name: fd-ticket
description: Create or update one Linear implementation ticket that maps to one focused pull request and one coherent semantic change. Use when the user asks for a single implementation ticket or asks to populate an existing issue. Do not use to plan or decompose a multi-ticket feature; use fd-plan.
---

# Create Linear Implementation Ticket

Create or update one Linear issue that defines one reviewable implementation
change. Linear is the source of truth. Do not create local feature-design files.

## Argument

Accept a ticket title, feature description, or Linear issue identifier such as
`FD-012` in `$ARGUMENTS`.

## Ticket Boundary

- Design the ticket so one pull request can complete it.
- Keep one coherent semantic change in that pull request.
- Include the tests, migrations, and documentation required to complete that
  change. Do not split them out only to reduce the diff size.
- Exclude unrelated cleanup and independently useful behavior.
- If the request needs multiple independent semantic changes, use `fd-plan`
  instead of combining them in one ticket.

## Linearis Runtime

The shared installer validates that the Linearis CLI supports the required
issue commands. Use `linearis` when available. Otherwise, use the supported
`linear` alias.

Run authentication checks and issue commands with network access outside the
sandbox. If a sandboxed `auth status` reports `authenticated: false`, retry
with network access before treating the token as invalid.

Before creating a ticket, run `linearis auth status`. Require
`authenticated: true`, and use `user.id` as the assignee. If Linearis is
missing, requires authentication, or exits with code 42, stop and show its
setup instruction. Do not install or authenticate automatically.

## Workflow

### 1. Select the issue

- If `$ARGUMENTS` contains an issue identifier matching
  `[A-Z][A-Z0-9]*-[0-9]+`, read and update that issue.
- Preserve useful existing content. Ask before replacing it wholesale.
- If there is no issue identifier, create a new issue.
- Infer the team and project only from explicit user input, repository
  conventions, referenced issues, or clearly relevant Linear context.
- Require a project for a new issue. Ask when the team or project is ambiguous.
- Never create a project automatically.

### 2. Define the implementation contract

- Inspect the current repository when the request depends on existing code.
- State the user-visible or operational outcome.
- Define explicit in-scope and out-of-scope boundaries.
- Name the relevant code paths relative to the repository root.
- Convert absolute paths inside the repository to repository-relative paths.
- Use absolute paths only for genuine external dependencies or artifacts.
- Define observable acceptance criteria and focused verification.
- Record known blockers with Linear relations, not only in prose.

### 3. Write the description

Use this structure:

```md
## Summary

<1-3 sentences that state the outcome and why it matters.>

## Problem

<The concrete problem this ticket solves.>

## Scope

- In scope: <included behavior>
- Out of scope: <excluded behavior>

## Implementation

<The intended approach and important constraints.>

### Files to Create or Modify

| File | Action | Purpose |
|------|--------|---------|
| `path/to/file` | CREATE / MODIFY | What and why |

## Acceptance Criteria

- [ ] <Observable result>

## Verification

<Commands or checks that prove the acceptance criteria.>

## Dependencies

- Blocked by: <issue or None>
- Blocks: <issue or None>

## Related

- <Related tickets, documents, pull requests, or issues>
```

Keep `Summary` concise. Use the remaining sections as the implementation
contract. Remove empty optional rows or bullets instead of leaving meaningless
placeholders.

### 4. Write the issue

- Create a new issue with `issues create <title> --team <team> --project
  <project> --status TODO --assignee <authenticated-user-id> --description
  <body>`.
- Add `--parent-ticket`, `--blocked-by`, or `--blocks` when the user or a
  feature plan provides those relationships.
- Update an existing issue with `issues update <issue> --description <body>`.
- Preserve an existing issue's status, assignee, project, parent, and relations
  unless the user asks to change them.
- Preserve the JSON output from Linearis.

### 5. Report

Report the issue identifier, URL, parent, and blocking relations. List only the
sections that still need user input. Do not commit repository changes.
