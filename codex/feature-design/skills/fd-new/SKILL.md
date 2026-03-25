---
name: fd-new
description: Create a new Feature Design (FD) file from a title or feature description.
---

# Create New Feature Design

Create a new FD file.

## Argument

Title or description of the feature: `$ARGUMENTS`

## Steps

### 1. Determine the next FD number

- Scan `docs/features/` and `docs/features/archive/` for files named like `FD-XXX_*.md`
- If needed, also inspect FD headings inside those files for `FD-XXX`
- Find the highest FD number present
- Next number = highest + 1 (start at 1 if no FDs exist)
- Pad to 3 digits: FD-001, FD-002, etc.

### 2. Parse the argument

- Extract a title from `$ARGUMENTS`
- If no argument provided, ask the user for a title and brief description
- Generate a filename-safe slug from the title (UPPER_SNAKE_CASE)

### 3. Ensure the directory exists

- Create `docs/features/` if it does not already exist

### 4. Create the FD file

- File: `docs/features/FD-{number}_{SLUG}.md`
- Create the file with this structure:

```md
# FD-{number}: {Title}

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

- Fill in: FD number and title
- If the user provided enough context, fill in Problem and Solution sections
- Otherwise leave them as placeholders for the user to fill

### 5. Skip the index

Do not create or update a feature index/list file.

### 6. Report

Print the created FD with its number, file path, and what sections need filling in.
Do NOT commit - the user will fill in details first.
