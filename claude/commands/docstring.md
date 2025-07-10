---
name: docstring
description: Add docstrings and type hints to Python files
---

Add documentation to modified Python files: $ARGUMENTS (or all modified files)

1. **Get modified files**: `git diff --name-only HEAD` + `git status --porcelain` (filter .py files)
2. **Add Google-style docstrings**:
   - Modules, classes, functions/methods
   - Include Args, Returns, Raises sections
3. **Add type hints**:
   - Function parameters and returns
   - Use modern syntax (built-in types, `|` for unions)
4. **Python version-specific features**:
   - 3.12+: `type` statement, `override` decorator
   - 3.11+: `Self` type, exception groups
   - 3.10+: structural pattern matching
5. **Update documentation**: README.md and Makefile if needed