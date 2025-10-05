# PR Review Command

You are conducting a thorough code review of a pull request.

## Context
- We are reviewing changes locally on the current branch against main
- PR URL (if provided): $ARGUMENTS
- Use `gh pr view $ARGUMENTS` if a PR URL/number is provided to fetch PR details

## Review Protocol

### 1. Understand the Changes
- Run `git diff main...HEAD` to see all changes in this branch
- Run `git log main..HEAD --oneline` to see commit history
- If PR URL provided, run `gh pr view $ARGUMENTS` to get PR description and metadata

### 2. Deep Analysis Requirements
YOU MUST:
- Read EVERY changed file completely, not just the diff
- Read related files that interact with changed code (imports, callers, dependencies)
- Understand the broader context and system architecture
- Trace data flow through the system
- Consider edge cases and error handling paths

### 3. Review Focus Areas
Report these issues with HIGH PRIORITY:
- **Logic errors**: Off-by-one errors, incorrect conditionals, wrong algorithm implementations, edge case bugs
- **ML/Data issues**: Incorrect tensor shapes, wrong loss functions, data leakage, improper train/val/test splits, missing normalization, incorrect metric calculations
- **Python issues**: Type mismatches, incorrect async usage, memory leaks, resource leaks (unclosed files/connections)
- **Performance issues**: O(n²) algorithms, inefficient vectorization, unnecessary loops over large datasets, memory inefficiency
- **Correctness**: Incorrect business logic, broken error handling, improper exception handling
- **Reproducibility**: Missing random seeds, non-deterministic operations, unreproducible experiments

### 4. Code Quality Issues
ONLY report code quality issues if they:
- Create significant maintenance burden
- Make debugging harder (e.g., missing type annotations, poor variable names in complex logic)
- Violate critical ML best practices (e.g., no validation set, training on test data)

### 5. Testing & Validation
Check for:
- Missing tests for critical logic paths
- Tests that don't actually verify the behavior
- Missing edge case coverage
- Proper error case testing

### 6. Output Format
Structure your review as:

**Summary**: Brief overview of changes and overall assessment

**Critical Issues** (if any):
- Issue description, file location (file.py:line), severity, fix recommendation

**Major Concerns** (if any):
- Issue description, file location, impact, suggested approach

**Minor Issues** (if any):
- Brief list with file locations

**Positive Observations**:
- Well-implemented aspects worth noting

Be direct and specific. Use file:line references. Prioritize ruthlessly.
