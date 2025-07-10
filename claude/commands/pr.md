---
name: pr
description: Create or update PR with tags from commits
---

Create or update PR for current branch: $ARGUMENTS (optional PR description)

1. **Validate branch**: Exit if on main/master
2. **Get commits**: Find base branch and commits between base..HEAD
3. **Extract tags**: Parse unique tags from commit messages (format: XXX-####)
4. **Check existing**: `gh pr list` for current branch
5. **Generate PR**:
   - **Title**: `[TAG-1] [TAG-2] Description`
   - **Body**: Summary + commits grouped by tag + test checklist
6. **Create/update**:
   - New: `gh pr create --base <detected> --title "..." --body "..."`
   - Existing: `gh pr edit --title "..." --body "..."`

**Note**: No Claude attribution in PR content