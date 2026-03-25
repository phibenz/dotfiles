---
name: fd-context
description: Build focused implementation context for a specific Feature Design (FD). Use when the user provides an FD id (FD-XXX) and wants project, codebase, and recent activity context tailored to that FD.
---

# FD Context

Create an FD-specific briefing for a single feature design.

## Argument

Required: `FD-XXX`
Optional: additional user description or focus area

If the argument does not include an `FD-XXX` token, ask the user to provide it before continuing.

## Step 1: Project Overview

Explore the project root to understand what this project is and how it works:

1. Read key docs - `AGENTS.md`, `README.md`, top-level docs
2. Directory structure - list top-level files and key subdirectories
3. Tech stack - identify languages, frameworks, and build tools from config files (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Makefile`, etc.)
4. Gotchas - note warnings, constraints, and conventions from `AGENTS.md` (or equivalent project guidance doc)

Return: project name, purpose, tech stack, directory layout, key gotchas.

## Step 2: FD Deep Dive

Explore the codebase and recent activity specifically for the target FD (`FD-XXX`):

1. Locate and read the FD file for the target ID by searching `docs/features/` (and `docs/features/archive/` if needed)
2. Extract problem statement, solution approach, verification plan, and files to modify from the FD
3. Map FD scope to actual code by inspecting referenced files and discovering related modules
4. Identify dependencies, integration points, and potential risk areas tied to this FD
5. Find recent commits referencing the FD id or related feature keywords
6. Summarize last 15 commits with emphasis on FD-relevant changes
7. List files changed in the last 5 commits that overlap with FD scope
8. Report branch context (current branch and ahead/behind main)
9. Check uncommitted work and flag items related to this FD

Return: FD summary, planned file touchpoints, relevant modules, risks, implementation notes, FD-relevant commit summary, files in flux, branch status, and open work related to the FD.

## Step 3: Synthesize Results

Combine agent outputs into a single FD-focused briefing.

### Project Overview

- Name, purpose, tech stack
- Key constraints and gotchas

### FD Context (`FD-XXX`)

- FD title and status
- Problem and solution summary
- Expected files/modules to change
- Key risks and unknowns

### Recent Activity (FD-Scoped)

- What changed recently for this FD
- Current branch and open work affecting this FD

### Quick Reference

| Item | Value |
|------|-------|
| **Project** | {name} |
| **FD** | {FD-XXX} |
| **Branch** | {current branch} |
| **FD Status** | {status} |
| **Recent FD focus** | {summary} |

## Working Directory

Use the current working directory as project root.
