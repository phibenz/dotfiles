---
name: ticket
description: Draft and revise one local implementation ticket. Each ticket maps to one focused pull request and one coherent semantic change. Use for a single implementation ticket or an existing local draft. Use plan for automated planning and review, or outline for a multi-ticket outline.
---

# Draft an Implementation Ticket

Define one reviewable change in a canonical local Markdown file.
Use [plan](../plan/SKILL.md) for automatic drafting and review rounds.

## 1. Identify the draft and boundary

- Accept a title, description, local draft path, or local ID such as `T3.1` in `$ARGUMENTS`.
- Read [Manage Local Planning Files](references/drafts.md) for origin storage, feature folders, IDs, and revisions.
- Apply [PR Workspaces](references/workspaces.md) before detailed planning for a new feature.
- Resolve supplied drafts and IDs to their canonical origin location. Preserve source files, useful content, and agreed requirements.
- Use [Define Ticket and Step Boundaries](references/boundaries.md) to derive one coherent PR and its commit steps.
- Split independent outcomes through [outline](../outline/SKILL.md). Exclude unrelated cleanup.
- Ask before changing the authorized outcome, scope, or compatibility promises.

## 2. Establish the contract

- Inspect relevant production code, callers, interfaces, and nearby verification. Use the repository's actual patterns.
- Verify referenced paths, symbols, signatures, and fixtures. Distinguish existing code from proposed additions and unavailable evidence.
- State the required behavior, scope, failure handling, compatibility, and integration constraints.
- Keep the change as small as those requirements permit. Justify added abstractions, state, and recovery with a current requirement.
- Leave ordinary implementation choices open. Use [design](../design/SKILL.md) for unresolved consequential choices; reuse valid decisions.
- Use repository-relative code paths and absolute paths for external dependencies or artifacts.
- Record blockers in draft metadata.

## 3. Write the ticket

Use [assets/ticket.md](assets/ticket.md). Keep bullets concise and omit unnecessary sections or detail.

- **Objective:** state the concrete outcome. Split independent outcomes rather than adding them to this ticket.
- **Non-Goals:** include agreed exclusions only when they clarify the boundary.
- **Problem:** explain the concrete problem and necessary background.
- **Design Rationale:** explain the chosen shape briefly. For consequential choices, record the strongest rejected alternative and deciding evidence or tradeoff.
- For routine changes, explain the existing pattern in one sentence. Reference shared rationale in the parent plan without repeating it.

### Implementation steps

- Name numbered steps after observable behavior. Each step becomes one coherent commit with the needed code, tests, and documentation.
- Use three parts per step: **Purpose**, **Proposed Change**, and **Verification**.
- **Purpose:** explain the behavior change and why it matters in one sentence.
- **Proposed Change:** name relevant paths and symbols, required changes, constraints, and contracts that dependents rely on.
- Use a sketch only when prose cannot explain an important contract or interaction clearly. Mark proposed symbols and incomplete scaffolding.
- Keep sketches focused; do not draft the entire patch or freeze ordinary implementation choices.
- When proposing functions, include accurate docstrings where the language supports them. Follow repository conventions.
- **Verification:** define a concrete recipe through [Define Verification Recipes](../verify/references/recipes.md), including an observable pass condition.
- Reuse existing verification when it proves the behavior. Add tests only when they protect a contract or plausible regression at a useful boundary.
- Use `tdd` when selecting, adding, or reviewing tests. A new test or a test-first cycle is not required for every step.
- Check whether removing a step leaves the objective incomplete. Remove unnecessary work and equivalent verification; preserve distinct failure modes.
- Refine later steps as earlier work reveals more. Update dependent contracts, rationale, and verification when the design changes.

## 4. Report

- Report the canonical draft path, local ID, parent or prerequisite relations, and unresolved questions.
- Use [assess](../assess/SKILL.md) for a requested read-only assessment, or `plan` for automatic review rounds.
- Drafting does not authorize implementation or commits. `plan` presents the reviewed planning checkpoint before coding.
