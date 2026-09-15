---
name: fd-readiness
description: Review one local ticket draft or Linear implementation issue against the codebase and decide whether implementation can start. Use for readiness checks, material ambiguities, blockers, and design risks. Use fd-plan for parent feature plans.
---

# Review Ticket Readiness

Determine whether implementation can start without guessing material behavior or
design. Review one implementation ticket, not the parent feature plan.

Read `fd-ticket` for the ticket contract and read-only Linearis runtime guidance.
Use its sizing, code-grounding, and implementation-step rules as review criteria,
not as permission to draft, publish, or implement changes.

## 1. Select the ticket and checkout

- Accept a local draft path, including an unpublished ticket, or a Linear issue ID.
  Ask for a target only when the conversation does not identify one unambiguously.
- Review the requested source. If a local draft and Linear differ, state which
  version you assessed rather than combining them silently.
- For Linear reads, use the runtime guidance in `fd-ticket`. Local reviews need
  no Linear access unless missing issue context materially affects the assessment.
- Read parent context, predecessor tickets, or discussions only when they resolve
  relevant boundaries or decisions. For a parent-only request, ask which child to assess.
- Use the current checkout's Git root for inspection and relative paths. Translate
  paths from another worktree of the same repository to this root; keep genuine
  external paths separate.
- Keep the review read-only. Requested revisions go through `fd-ticket` and its
  local-draft approval workflow; report findings here rather than posting update comments.

## 2. Establish the implementation base

- Inspect the current branch, relevant diffs, and uncommitted changes.
- For a stacked PR, identify the predecessor branch from the plan and repository
  evidence. Assess the ticket's incremental change against that branch.
- For the first PR or a standalone ticket, identify the actual target branch.
  State uncertainty when the base cannot be established.
- An unmerged predecessor is not a blocker when its required code is available.
  Inspect the predecessor's code read-only if it is absent from the current checkout.
- Distinguish missing prerequisite work from unavailable evidence. Keep the checkout
  fixed and report which base you assessed.

## 3. Check the implementation contract

- Read the objective and each step's paired testing and implementation work.
  Judge substance; equivalent wording or older headings do not make a ticket unready.
- Check that the ticket forms one focused PR and its steps form coherent commits
  using the `fd-ticket` boundaries and sizing guidance.
- Trace referenced code, callers, interfaces, schemas, and nearby tests. Check
  proposed changes against existing contracts and reusable helpers.
- Distinguish existing symbols from proposed additions. For new code, assess
  placement and integration rather than treating its absence as a blocker.
- Treat snippets as proposed scaffolding. Flag stale assumptions that change
  behavior or design, not harmless differences in implementation detail.
- Use the `tdd` skill to assess whether test scenarios protect observable behavior
  at useful boundaries and whether their expected results are meaningful.
- Check ownership, shared contracts between steps, migration and compatibility
  requirements, external prerequisites, and conflicts with relevant local work.

## 4. Judge and report

- `Ready`: implementation can start; remaining choices are normal implementation details.
- `Mostly Ready`: implementation can start with explicitly stated minor assumptions.
- `Needs Design Work`: material behavior or design decisions need resolution.
- `Blocked`: a confirmed prerequisite prevents implementation.
- `Not Assessed`: essential evidence is unavailable, so no readiness verdict is supported.
- Separate review limitations from ticket findings. Report confirmed findings even
  when other checks are incomplete; qualify any verdict by those limits.
- For each finding, give concrete evidence, its consequence, and the simplest
  supported resolution. Treat minor preferences as non-blocking.
- Ask only questions that require a user decision. Recommend code-supported defaults
  for choices that can be resolved from the repository.
- Read and use [assets/review.md](assets/review.md). Keep each finding in one place;
  omit empty optional sections. If ready without findings, say so briefly.
