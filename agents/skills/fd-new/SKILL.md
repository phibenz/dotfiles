---
name: fd-new
description: Use this skill to create a new Linear feature-design ticket or populate/update an existing Linear issue as a feature-design ticket with Linearis. Trigger when the user explicitly asks for a new FD, feature design, design ticket, implementation plan ticket, or asks to populate/update a Linear issue as a design ticket. Do not use for readiness, status, lookup, or other non-mutating requests that merely mention a Linear issue id.
---

# Create Linear Feature Design

Create or update a Linear issue that holds the feature design. Linear is the
source of truth; do not create local `docs/features` files.

## Argument

Title, description, or Linear issue id for the feature: `$ARGUMENTS`

Optional: the argument may include an explicit Linear issue id such as `FD-012`,
`RL-635`, or another uppercase prefix plus number.

## Linearis Runtime

The agent skill installer validates that the Linearis CLI exists and supports
the required issue commands. Do not repeat that preflight for every FD request.
Use `linearis` when available; otherwise use the supported `linear` alias.

Before creating a new ticket, run `linearis auth status`, require
`authenticated: true`, and read `user.id` from its JSON response. If it is not
authenticated or has no user id, stop and surface its auth instruction. Use
that UUID as the assignee so the ticket is assigned to the current Linearis
account regardless of its display name or workspace.

If Linearis is missing, exits with an authentication-required JSON error, or
exits with code 42, stop and surface the setup or auth instruction to the user.
Do not install or authenticate automatically because those flows are
environment-specific and may be interactive.

## Steps

### 1. Determine the target ticket

- If the argument includes an explicit issue id token matching
  `[A-Z][A-Z0-9]*-[0-9]+`, use that exact Linear issue.
  - Read it with Linearis before modifying it.
  - If it already has useful content, update the description instead of
    creating a duplicate ticket.
- If no explicit issue id is provided, create a new Linear issue.
  - Linearis issue creation requires `--team`. Infer the team only from
    explicit user input, current repo conventions, current branch naming, or
    clearly relevant Linear context.
  - If the team is not clear, ask the user for the Linear team before creating
    the ticket.

### 2. Parse the feature request

- Extract the feature title from `$ARGUMENTS`.
- If an explicit issue id token is present, remove it from the title text.
- If no usable title or description is provided, ask the user for the missing
  context before creating or updating the ticket.

### 3. Write repo-root-relative references

- Treat the current git repository root as the project root.
- When the design names files, modules, commands, docs, schemas, datasets, or
  tests that live inside the repository, write those paths relative to the repo
  root.
  - Good: `packages/api/src/server.py`
  - Avoid: `/Users/name/work/repo/packages/api/src/server.py`
- If the user provides an absolute path that is inside the current repo,
  convert it to a repo-relative path before writing it into the ticket.
- Use absolute paths only when the referenced path is genuinely outside the
  repository, such as a sibling checkout, external data directory, generated
  artifact cache, or user-specific tool path.

### 4. Compose the Linear description

Use this structure:

```md
## Human

<1-3 concise sentences explaining what this ticket does and why. Keep this
section short enough for quick triage.>

## Agent

### Problem

What we're solving and why it matters.

### Solution

How to implement it. Be specific about approach.

### Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `path/to/file` | CREATE / MODIFY | What and why |

### Verification

How to test that it works. Concrete steps.

### Related

- Links to related tickets, docs, PRs, or issues
```

- The `Human` section is for fast human scanning: concise, non-exhaustive, and
  written in product or workflow terms.
- The `Agent` section is the implementation contract: detailed enough for an
  agent to start work, but still understandable to a human who wants depth.
- If the user provided enough context, fill in the `Problem`, `Solution`, and
  `Verification` sections.
- If the implementation details are not known, leave explicit placeholders that
  say what must be decided.

### 5. Write the ticket with Linearis

- For a new ticket, use
  `issues create <title> --team <team> --description <body>` with
  `--status TODO` and `--assignee <authenticated-user-id>`.
- Use `issues update <issue> --description <body>` for an existing ticket.
- For an existing ticket, preserve and merge any useful existing description
  content; ask before replacing it wholesale.
- Preserve an existing ticket's status and assignee unless the user explicitly
  asks to change them.
- Preserve the JSON output from Linearis and report the issue identifier and URL
  from that output.

### 6. Report

Print the Linear issue identifier, URL, and any sections that still need user
input.
Do not create local feature-design files and do not commit.
