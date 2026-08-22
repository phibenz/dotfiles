---
name: elegance
description: Use this skill to review recent code changes for simplicity, readability, structure, craft, and elegance. Trigger when the user asks whether changes are the most elegant version, whether code can be simplified or restructured for comprehension, whether stronger modeling or language and library concepts would improve the implementation, whether the implementation follows "as simple as possible, as complex as necessary", or asks for a craft-focused pass on code quality.
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
   - Would reorganizing the code around responsibilities, lifecycle, or data
     flow make the main path easier to comprehend?
   - Is the problem represented with the clearest concepts and data model, or
     are primitive values, unstructured dictionaries, string flags, parallel
     collections, or scattered validation hiding the domain?
   - Would an established language, standard-library, or project-native
     concept remove custom machinery and make invariants explicit? Depending on
     the context, examples include an enum for closed states, a dataclass or
     value object for cohesive data, a protocol for a real interface, a context
     manager for resource lifetime, or Pydantic for validation-heavy external
     data boundaries.
   - Can mutation, cross-layer coupling, or implicit state be reduced so that
     readers need less context to understand the behavior?
   - Does the implementation fit the repository's existing style?
   - Are tests focused on functionality and observable behavior rather than
     implementation trivia?
   - Are any tests naive, purely mechanical, or only restating the code instead
     of increasing confidence? If so, recommend removing them.
   - Do any negative or regression tests reject deleted syntax or describe
     states that the current design can no longer produce? Check this in every
     review, not only after cleanup work. If a test only preserves history about
     deleted code and protects no current observable contract, remove the test
     and any production guard, error path, compatibility behavior, or comment
     that exists only to satisfy it.
   - Keep tests for active invariants that supported inputs can still violate.
     Examples include positive timeout values, safe paths, and executable
     entrypoints. Do not remove useful behavior coverage merely because the
     original implementation changed.
   - Is there duplicated or dead code that should be deleted?
4. Separate real improvements from taste.
   - Call out changes that reduce complexity, risk, or future maintenance.
   - Avoid churn that only makes the code different.
   - Preserve explicitness when it makes edge cases easier to reason about.
   - Recommend a new type, abstraction, framework, or dependency only when it
     replaces meaningful bespoke logic, centralizes real invariants, or makes
     multiple call sites easier to understand. Do not introduce one merely
     because it is more sophisticated or fashionable.
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
