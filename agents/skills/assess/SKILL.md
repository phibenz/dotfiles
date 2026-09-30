---
name: assess
description: Assess a feature plan, implementation ticket, or significant contract revision against current code without editing it. Use for readiness checks, plan reviews, material ambiguities, blockers, and design risks. Use plan to automate drafting and review rounds.
---

# Assess the Plan and Implementation Contract

Assess the requested planning scope against repository evidence.
A coherent parent plan does not establish readiness for its future tickets.

## 1. Select the scope and evidence

- Read [Manage Local Planning Files](../ticket/references/drafts.md) as storage criteria without initializing files.
- Accept canonical origin draft paths, local ticket IDs, or a changed contract with relevant drafts and diffs.
- Review the plan and next ticket together when requested. Review either alone when that is the requested scope.
- For implementation revisions, include the changed contract and affected remaining steps or ticket outlines.
- Ask for a target only when the conversation does not identify one unambiguously.
- Identify the canonical local draft revision that you assess.
- Read parent context, predecessor tickets, and discussions only when they resolve relevant boundaries or decisions.
- Use the current checkout's Git root for inspection and relative paths.
- Translate repository code paths to the assessed implementation checkout. Keep canonical origin planning paths absolute.
- Record the origin store separately from the implementation checkout using [PR Workspaces](../ticket/references/workspaces.md) as context criteria.
- Keep the assessment read-only. Return findings without editing drafts, saving reports, or publishing comments.
- Identify whether the reviewer helped draft or implement the assessed design.
- Coordinators must use [Independent Contract Review](references/contract-review.md) for significant shared contracts.

## 2. Establish the implementation base

- Inspect the current branch, relevant diffs, and uncommitted changes, including relevant untracked files.
- For a stacked PR, identify the predecessor branch from the plan and repository evidence.
- Assess the ticket's incremental change against that branch.
- For the first PR or a standalone ticket, identify the actual target branch.
- State uncertainty when the base cannot be established.
- An unmerged predecessor is not a blocker when its required code is available.
- Inspect predecessor code read-only when it is absent from the current checkout.
- Distinguish missing prerequisite work from unavailable evidence. Keep the checkout fixed and report the assessed base commit.
- Check future outlines for consistent contracts and ordering. Do not assign readiness without available prerequisite code.

## 3. Assess the plan and contract

Use [Define Ticket and Step Boundaries](../ticket/references/boundaries.md) for work boundaries.
For ticket scope, read [ticket](../ticket/SKILL.md) as criteria, without running its drafting workflow.

- Check that the plan achieves the complete outcome through coherent boundaries, shared contracts, and prerequisite order.
- Identify missing behavior, duplicated work, unnecessary abstractions, and unsupported compatibility paths.
- Check that the next ticket delivers one coherent PR and that each remaining step forms one verifiable commit.
- Read the objective and each step's purpose, proposed change, and verification. Judge substance rather than exact headings.
- Trace referenced code, callers, interfaces, schemas, and nearby tests against existing contracts and reusable helpers.
- Identify work that can be removed or simplified without losing required behavior or verification.
- Prefer clear ownership, direct control flow, and existing contracts. Require a concrete need for added abstractions or state.
- Check recovery guarantees, compatibility paths, and tests against current requirements and concrete failure modes within scope.
- Assess large changes by necessity and coherence. Explain any useful split through behavior and code evidence.
- Distinguish existing symbols from proposed additions. Assess new code's placement and integration without treating its absence as a blocker.
- Treat snippets as proposed scaffolding. Flag stale assumptions that change behavior or design, rather than harmless implementation details.
- Assess the Design Rationale and consequential comparisons against the constraints and code using [design](../design/SKILL.md) as criteria.
- Do not run its authoring workflow or create a replacement design during this read-only assessment.
- Check ownership, migration requirements, external prerequisites, and conflicts with relevant local work.
- Trace significant contract changes through affected callers, remaining steps, and indirect ticket dependents.
- Use `tdd` when assessing whether test scenarios protect observable behavior at useful boundaries.
- Use [Define Verification Recipes](../verify/references/recipes.md) to assess concrete recipes and observable pass conditions.
- Check whether verification detects contract violations. Distinguish existing verification from planned additions.
- Reuse credible verification evidence for unchanged code and conditions. Rerun checks when stale evidence or a specific concern warrants it.
- For implementation revisions, inspect the actual diff and verification evidence before assessing the remaining work.

## 4. Judge and return the report

- `Coherent`: the assessed plan or contract fits the agreed outcome and constraints. This does not establish ticket readiness.
- `Ready`: the assessed ticket or remaining steps can start. Remaining choices are normal implementation details.
- `Mostly Ready`: implementation can start with explicitly stated minor assumptions.
- `Needs Design Work`: material behavior or design decisions need resolution.
- `Blocked`: repository evidence establishes a prerequisite that prevents the assessed work.
- `Not Assessed`: essential evidence is unavailable, so no supported assessment is possible.
- Report separate plan and ticket results when both are in scope.
- Separate review limitations from findings. Report findings supported by evidence even when other checks remain incomplete.
- Qualify the result by evidence limits. Do not treat unavailable independent review as a completed assessment.
- Give concrete evidence, consequence, and the smallest supported resolution for each finding.
- Consider removing unnecessary requirements before adding machinery. Treat stylistic preferences as non-blocking.
- Ask only questions that require a user decision. Recommend code-supported defaults for ordinary design choices.
- Return [assets/review.md](assets/review.md) with empty optional sections omitted.
- Include the assessed scope, base commit, relevant local changes, assumed contracts, and reviewer independence.
- The caller saves the report when the workflow requires a local record. A standalone assessment remains read-only.
