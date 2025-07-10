---
name: commit
description: Create atomic git commits with Conventional Commits format
---

Create atomic commits with optional JIRA tag: $ARGUMENTS

1. **Check status**: `git status` and `git diff` to analyze changes
2. **Split by type**: Group changes into atomic commits (feat/fix/docs/test/etc)
3. **Stage selectively**: Use `git add -p` to separate unrelated changes
4. **Commit format**: `[TAG] type: description`
   - Extract tag from branch name or use $ARGUMENTS
   - Types: feat, fix, docs, test, refactor, chore
   - Keep under 120 chars
5. **Push**: Push all commits (skip if main branch)
