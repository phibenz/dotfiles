---
name: lint
description: Run linting and auto-fix all issues
---

Run linting and fix issues: $ARGUMENTS (specific files or --all-files)

1. **Run linter**: `uv run pre-commit run $ARGUMENTS`
2. **Fix failures**:
   - Auto-fixable: Apply fixes automatically
   - Manual fixes: Read files, apply suggestions, explain changes
3. **Re-run**: Verify all issues resolved
4. **Summary**: Report what was fixed
