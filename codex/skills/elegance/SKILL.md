---
name: elegance
description: Review recent code changes for simplicity, craft, and elegance. Use when the user asks whether changes are the most elegant version, whether code can be simplified, whether the implementation follows "as simple as possible, as complex as necessary", or asks for a craft-focused pass on code quality.
---

# Elegance Review

Assess whether the current changes are the simplest good version of the work:
as simple as possible, as complex as necessary.

## Workflow

1. Establish the review scope from the user's request.
   - Review staged changes when the user refers to staged work, a commit, or
     commit preparation.
   - Review branch changes when the user refers to the branch, PR, or changes
     compared to a base branch.
   - Otherwise review the current working tree diff.
   - Do not broaden the scope to unrelated named files or surrounding code
     except as needed to understand the selected changes.
2. Understand the intent before judging the shape of the code.
   - Read surrounding code and existing patterns.
   - Identify constraints that justify complexity.
   - Do not optimize for terseness at the cost of clarity or correctness.
3. Review for elegance and craft:
   - Can the same behavior be achieved with fewer moving parts?
   - Are abstractions pulling their weight?
   - Is naming precise enough that the code explains itself?
   - Are conditionals, state, and data flow localized and easy to follow?
   - Does the implementation fit the repository's existing style?
   - Are tests focused on functionality and observable behavior rather than
     implementation trivia?
   - Are any tests naive, purely mechanical, or only restating the code instead
     of increasing confidence? If so, recommend removing them.
   - Is there duplicated or dead code that should be deleted?
4. Separate real improvements from taste.
   - Call out changes that reduce complexity, risk, or future maintenance.
   - Avoid churn that only makes the code different.
   - Preserve explicitness when it makes edge cases easier to reason about.
5. If the user asked for implementation, make the cleanup directly and verify
   it. Otherwise provide a concise review with concrete recommendations.

## Output Style

- Start with the answer: whether the current version is already elegant enough
  or what is holding it back.
- Prioritize high-leverage simplifications first.
- Tie each recommendation to a specific file, line, or code path.
- Explain the tradeoff in plain engineering terms.
- When discussing tests, distinguish behavior coverage from mechanical coverage.
- If no meaningful simplification is available, say that clearly.
- Do not invent abstractions to appear sophisticated.

## Review Bias

Favor code that is boring, direct, and locally understandable. Complexity is
acceptable when it buys correctness, performance, reuse across real call sites,
or a clearer domain model. Everything else should earn its place.
