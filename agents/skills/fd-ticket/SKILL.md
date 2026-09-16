---
name: fd-ticket
description: Draft and revise one implementation ticket locally, then publish it to Linear after approval. Each ticket maps to one focused pull request and one coherent semantic change. Use for a single implementation ticket or an existing issue. Use fd-plan for a multi-ticket feature.
---

# Draft and Publish an Implementation Ticket

Define one reviewable implementation change in a local Markdown file. Iterate on
that file with the user before creating or updating the Linear issue.

## Argument

Accept a ticket title, feature description, local draft path, or Linear issue
identifier such as `FD-012` in `$ARGUMENTS`.

## Local Drafts and Approval

- Use `docs/fd/<ticket-id>-<slug>.md` unless the user supplies another path.
  For unpublished tickets, use a temporary ID such as `T1`.
- Reuse the draft during revisions and preserve unrelated files. Keep title,
  issue ID, team, project, and relations separate from the description.
- Draft locally; use Linear only for read-only context until publication approval.
- Share the path and publish only after explicit approval of the current draft.
  Later revisions require renewed approval.
- Retain the published ID and URL locally. Replace the temporary ID in default
  filenames and draft links with the real ID after publication.

## Ticket Boundary

- Design the ticket so one pull request can complete it.
- Keep one coherent semantic change in that pull request.
- Prefer small, reviewable pull requests. Use 300–800 changed lines as a sizing
  guide, not a quota or hard limit. Count additions plus deletions.
- Do not pad a smaller change. Above 800 lines, check for smaller coherent changes.
  Use `fd-plan` when a meaningful split exists. Otherwise explain why the larger
  change is necessary and why splitting would weaken correctness or reviewability.
- Exclude unrelated cleanup and independently useful behavior.
- If the request needs multiple independent semantic changes, use `fd-plan`
  instead of combining them in one ticket.

## Complete, Minimal Design

- Aim for the smallest coherent change that fully achieves the objective.
  Preserve required failure handling, compatibility, integration, and verification.
- Judge minimality by necessary behavior and maintenance cost, not line count alone.
  Do not trade clarity or correctness for a smaller diff.
- Apply elegance principles: reuse existing contracts, keep ownership clear, and
  prefer direct control flow with few moving parts.
- Justify new abstractions, state, recovery guarantees, and compatibility paths
  with a current requirement or a concrete failure mode within scope.
- Resolve gaps with the simplest code-supported behavior that meets the contract.
  Do not add general frameworks or future-proofing only to remove uncertainty.
- State required behavior and shared contracts. Leave ordinary implementation
  choices open unless a specific design is necessary for correctness or integration.
- Before finalizing the draft, check whether removing each step would leave the
  objective incomplete. Remove unnecessary work and consolidate duplicate tests.

## Linearis Runtime

- Use `linearis`, or the supported `linear` alias. The shared installer checks
  command compatibility.
- Run Linear commands with network access outside the sandbox. Retry sandboxed
  authentication failures with network access before diagnosing invalid credentials.
- Before publication, require `linearis auth status` to report
  `authenticated: true`. Use `user.id` to assign new issues.
- If the CLI is missing, needs authentication, or exits with code 42, stop the
  Linear operation and show setup instructions. Leave installation and login to the user.
- Continue local drafting when context is sufficient; flag missing context.

## Workflow

### 1. Identify the draft and target issue

- When given a draft path, read that file and reuse its recorded target issue.
- If `$ARGUMENTS` contains an issue identifier matching
  `[A-Z][A-Z0-9]*-[0-9]+`, read that issue as context for a local update draft.
- Preserve useful existing content. Ask before replacing it wholesale.
- If neither the input nor the draft identifies an issue, draft a new issue
  without creating it yet.
- Infer the team and project only from explicit user input, repository
  conventions, referenced issues, or clearly relevant Linear context.
- Require a team and project before publishing a new issue. Record unresolved
  ownership in the draft and ask before publication.
- Never create a project automatically.

### 2. Define the implementation contract

- Inspect the relevant production code, callers, interfaces, and nearby tests
  before drafting implementation steps. Use the repository's actual patterns.
- Verify referenced paths, symbols, signatures, and fixtures. Distinguish
  existing code from proposed additions; flag any context you cannot inspect.
- State the user-visible or operational outcome.
- Define the explicit in-scope boundary.
- Name the relevant code paths relative to the repository root.
- Convert absolute paths inside the repository to repository-relative paths.
- Use absolute paths only for genuine external dependencies or artifacts.
- Read and follow the `tdd` skill before defining tests. Choose stable boundaries
  that expose the ticket's intended behavior.
- Record known blockers in the draft metadata.

### 3. Write and review the local description

Use concise bullets throughout, with one main idea per bullet and as many bullets
as needed. Use plain language and include only necessary information. Use focused
code blocks where they clarify the change.

Read and use [assets/ticket.md](assets/ticket.md) as the description template.

#### Objective

- In `Objective`, state the concrete outcomes the ticket must achieve.
- Treat many objective bullets as a sign that the ticket may be too broad.
  Review the boundary and split independent outcomes with `fd-plan`.

#### Non-Goals (optional)

- Add this section after `Objective` when exclusions clarify the boundary or
  preserve agreed non-goals. Use concise bullets; omit it otherwise.

#### Problem

- Explain the concrete problem and necessary background.

#### Implementation Steps

Use `Implementation Steps` with numbered subsections named after observable
behaviors. A ticket may contain several steps that together deliver one coherent
change. Keep tests, code locations, and implementation details together in each
step.

- Design each implementation step as one coherent commit containing its tests
  and production changes, with the relevant tests passing. A ticket's steps
  form the commit sequence for one pull request.
- Start each step with one sentence explaining what behavior changes and why,
  before naming code locations.
- Describe each step with concrete behavior and changes. Refine later steps as
  earlier steps reveal more.
- Within each step, use `#### Testing` followed by `#### Implementation` to
  distinguish the test work from production changes. Place sketches under the
  corresponding heading.

##### Testing within each step

- Pair one concrete test scenario with a short implementation plan. Identify the
  test path, observable expected result, and test boundary. Select tests using
  the `tdd` skill's confidence and cost rules.
- Keep behavior checks within the relevant implementation step.

##### Implementation within each step

- Group implementation changes by function or file within the step. Name the
  production paths and relevant symbols, with the required changes and constraints.
  Keep all changes for one behavior in that step.
- Include sketches only when they clarify a contract or important design choice.
  Precise prose is sufficient otherwise. Match the repository's language, APIs,
  and conventions. Choose the form that explains the change:
  - For a new or changed interface, a proposed signature, types, and behavior
    contract can clarify how callers use it.
  - For an existing function, a focused diff can clarify the relevant change.
    Include its path and function name; an unchanged signature alone adds little.
  - For a changed interaction, a short call-site example can explain how the
    components connect.
- State what dependent steps rely on: shared names, inputs, outputs, and behavior.
  Keep these contracts consistent across steps; do not add signatures mechanically.
- Keep snippets limited to the behavior and important design choices. Mark
  incomplete scaffolding and proposed symbols clearly; do not present them as
  existing or verified code. Do not write the entire patch during ticket drafting.
- Treat snippets as proposed scaffolding, not a frozen implementation. If the
  implementation refines a shared contract, update the dependent steps accordingly.
- Include accurate docstrings for proposed functions when the language supports
  them. Follow repository documentation conventions.

### 4. Publish the approved draft

- Reread the approved file and use its title and description as the publication
  content. Keep metadata and update notes local, outside the body and comments.
- For an existing issue, reread Linear before updating. If its content changed
  since drafting, reconcile the local draft and obtain approval again.
- Create a new issue with `issues create <title> --team <team> --project
  <project> --status TODO --assignee <authenticated-user-id> --description
  <body>`.
  Add `--parent-ticket`, `--blocked-by`, or `--blocks` for approved relations.
- Update an existing issue with `issues update <issue> --description <body>`.
  Preserve its status, assignee, project, parent, and relations unless requested
  changes are part of the approved draft.
- Preserve the JSON response and verify the content and relations with a Linear read.
- If publication partly succeeds, record the created identifier locally and
  report the remaining work. Do not create a duplicate on retry.

### 5. Report

- Before publication, report the draft path, unresolved questions, and the
  required approval. Do not claim that a Linear issue exists.
- After publication, report the issue identifier, URL, parent, and blocking
  relations, together with the retained draft path.
- Do not commit repository changes.
