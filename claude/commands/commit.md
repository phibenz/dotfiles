---
name: commit
description: Create single-line atomic commits with Conventional Commits format
---

Create single-line atomic commits:

**Format**: `type(scope): description`
- One line only, under 50 chars
- Imperative mood, lowercase
- No Claude Code attribution

**Types**: feat, fix, docs, style, refactor, test, chore
**Breaking**: `feat!: description`

1. `git status` and `git diff` to analyze changes
2. Group by type for atomic commits
3. Write concise single-line messages
