---
name: fd-new
description: Create a new feature design document from a title, feature description, or explicit design id such as FD-012 or RL-635.
---

# Create New Feature Design

Create a new feature design document.

## Argument

Title or description of the feature: `$ARGUMENTS`

Optional: the argument may include an explicit design id such as `FD-012`,
`RL-635`, or another uppercase prefix plus number.

## Steps

### 1. Determine the design id

- If the argument includes an explicit id token like `FD-012`, `RL-635`, or
  another token matching `[A-Z][A-Z0-9]*-[0-9]+`, use that exact id.
- When using an explicit id:
  - scan `docs/features/` and `docs/features/archive/` for an existing file or
    heading with that id
  - if it already exists, stop and tell the user instead of creating a duplicate
- If no explicit id is provided:
  - scan `docs/features/` and `docs/features/archive/` for files named like
    `FD-XXX_*.md`
  - if needed, also inspect headings inside those files for `FD-XXX`
  - find the highest FD number present
  - next number = highest + 1 (start at 1 if no FDs exist)
  - pad to 3 digits: `FD-001`, `FD-002`, etc.

### 2. Parse the argument

- Extract the design title from `$ARGUMENTS`
- If an explicit design id token is present, remove it from the title text
- If no argument provided, ask the user for a title and brief description
- Generate a filename-safe slug from the title (UPPER_SNAKE_CASE)

### 3. Ensure the directory exists

- Create `docs/features/` if it does not already exist

### 4. Create the design doc

- File: `docs/features/{DESIGN_ID}_{SLUG}.md`
- Create the file with this structure:

```md
# {DESIGN_ID}: {Title}

**Impact:** Brief description of what this enables

## Problem

What we're solving and why it matters.

## Solution

How to implement it. Be specific about approach.

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `path/to/file` | CREATE / MODIFY | What and why |

## Verification

How to test that it works. Concrete steps.

## Related

- Links to related FDs, docs, or issues
```

- Fill in: design id and title
- If the user provided enough context, fill in Problem and Solution sections
- Otherwise leave them as placeholders for the user to fill

### 5. Skip the index

Do not create or update a feature index/list file.

### 6. Report

Print the created design doc with its id, file path, and what sections need
filling in.
Do NOT commit - the user will fill in details first.
