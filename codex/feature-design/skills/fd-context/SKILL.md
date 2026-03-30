---
name: fd-context
description: Build focused implementation context for a specific feature design document. Accepts custom design ids such as FD-012 or RL-635 and gathers project, codebase, and recent activity context for that design.
---

# Design Context

Create a design-specific briefing for a single feature design.

## Argument

Required: a design id such as `FD-XXX`, `RL-635`, or another uppercase prefix
plus number

Optional: additional user description or focus area

If the argument does not include a design id token matching
`[A-Z][A-Z0-9]*-[0-9]+`, ask the user to provide it before continuing.

## Step 1: Project Overview

Explore the project root to understand what this project is and how it works:

1. Read key docs - `AGENTS.md`, `README.md`, top-level docs
2. Directory structure - list top-level files and key subdirectories
3. Tech stack - identify languages, frameworks, and build tools from config files (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Makefile`, etc.)
4. Gotchas - note warnings, constraints, and conventions from `AGENTS.md` (or equivalent project guidance doc)

Return: project name, purpose, tech stack, directory layout, key gotchas.

## Step 2: Design Deep Dive

Explore the codebase and recent activity specifically for the target design id:

1. Locate and read the design doc for the target id by searching
   `docs/features/` (and `docs/features/archive/` if needed)
2. Match either the filename prefix or the heading id
3. Extract problem statement, solution approach, verification plan, and files to modify from the design doc
4. Map design scope to actual code by inspecting referenced files and discovering related modules
5. Identify dependencies, integration points, and potential risk areas tied to this design
6. Find recent commits referencing the design id or related feature keywords
7. Summarize last 15 commits with emphasis on design-relevant changes
8. List files changed in the last 5 commits that overlap with design scope
9. Report branch context (current branch and ahead/behind main)
10. Check uncommitted work and flag items related to this design

Return: design summary, planned file touchpoints, relevant modules, risks,
implementation notes, design-relevant commit summary, files in flux, branch
status, and open work related to the design.

## Step 3: Synthesize Results

Combine agent outputs into a single design-focused briefing.

### Project Overview

- Name, purpose, tech stack
- Key constraints and gotchas

### Design Context (`ID`)

- Design title and status
- Problem and solution summary
- Expected files/modules to change
- Key risks and unknowns

### Recent Activity (Design-Scoped)

- What changed recently for this design
- Current branch and open work affecting this design

### Quick Reference

| Item | Value |
|------|-------|
| **Project** | {name} |
| **Design ID** | {ID} |
| **Branch** | {current branch} |
| **Design Status** | {status} |
| **Recent focus** | {summary} |

## Working Directory

Use the current working directory as project root.
