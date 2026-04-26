---
name: fd-readiness
description: Review a feature design document against the current codebase and decide whether it is implementation-ready. Use for design ids such as FD-012 or RL-635 when the user wants blockers, ambiguities, unresolved questions, and recommended clean-code resolutions before implementation.
---

# Feature Design Readiness Review

Evaluate whether a feature design is ready to implement against the current
repo state. The goal is not to produce a broad context dump. The goal is to
surface the concrete ambiguities, blockers, unresolved decisions, and code-path
risks that must be resolved before implementation starts.

## Argument

Required: a design id such as `FD-012`, `RL-635`, or another uppercase prefix
plus number.

Optional: a focus area, such as `API shape`, `migration path`, `tests`, or
`implementation plan`.

If the argument does not include a design id token matching
`[A-Z][A-Z0-9]*-[0-9]+`, ask the user to provide it before continuing.

## Review Goal

Answer the practical question:

> Can we start implementing this FD safely now, and if not, what exactly needs
> clarification or design adjustment?

Prefer concise, repo-grounded findings over exhaustive background. Do not
summarize the whole project unless a project constraint directly affects
readiness.

## Investigation Steps

1. Locate and read the target design doc.
   - Search `docs/features/` first.
   - Search `docs/features/archive/` if needed.
   - Match either the filename prefix or the heading id.

2. Extract only the implementation-relevant contract.
   - Objective and intended user-visible behavior.
   - Proposed architecture or code path.
   - Acceptance criteria and verification plan.
   - Files, modules, APIs, commands, schemas, or data paths the FD names.

3. Trace the real code paths.
   - Inspect the referenced files and nearby implementations.
   - Follow entry points, call sites, config/schema boundaries, and tests.
   - Check whether the proposed code path actually exists.
   - Identify existing helpers or abstractions that should be reused.
   - Look for simpler alternatives that fit the current architecture better.

4. Check current repo state.
   - Current branch and diff against the likely base branch.
   - Relevant uncommitted work.
   - Recent commits only when they overlap the FD scope.
   - In-flight changes that may conflict with the FD.

5. Judge implementation readiness.
   - `Ready`: implementation can start with no material open decisions.
   - `Mostly Ready`: implementation can start, but a few minor assumptions
     should be stated explicitly.
   - `Needs Design Work`: implementation would require guessing important
     behavior, ownership, API shape, migration strategy, or tests.
   - `Blocked`: a required prerequisite, dependency, code path, or decision is
     missing or contradictory.

## What To Look For

Focus on issues that would cause implementation churn, incorrect architecture,
or review pushback:

- Ambiguous behavior or acceptance criteria.
- Missing edge-case policy where the code must choose one behavior.
- Unclear ownership between modules or layers.
- Proposed paths that do not match the existing code architecture.
- Required APIs, schema fields, data, dependencies, or infra that do not exist.
- Migration, rollout, or compatibility decisions that are not specified.
- Verification plans that do not test the actual risk.
- Conflicts with current branch changes or recent relevant commits.
- Opportunities to solve the issue more cleanly by simplifying the design.

Do not inflate the list with speculative corner cases. If an issue is low-risk
or can be decided naturally during implementation, say so and do not treat it as
a blocker.

## Output Format

Keep the final response compact and action-oriented.

```md
Readiness: <Ready | Mostly Ready | Needs Design Work | Blocked>

Rationale:
<2-4 sentence repo-grounded explanation of the readiness rating.>

Issues To Resolve:
1. <Issue title>
   Evidence: <specific FD section, file, function, command, schema, or code path>
   Why it matters: <implementation/review risk>
   Recommendation: <cleanest professional solution>
   Blocking level: <blocker | should-resolve | minor assumption>

2. ...

Implementation Direction:
- <recommended clean code path or architecture choice>
- <reuse/simplification opportunities>
- <tests or verification that should be part of the implementation>

Open Questions:
- <only questions that truly need user/design input>
```

If there are no material issues, say that directly:

```md
Readiness: Ready

Rationale:
The FD maps cleanly to existing code paths and the remaining decisions are
normal implementation details.

Issues To Resolve:
None.

Implementation Direction:
- <short implementation direction>
- <focused verification>

Open Questions:
None.
```

## Assessment Rules

- Be concrete and repo-grounded; do not invent blockers without evidence.
- Always separate confirmed blockers from soft unknowns.
- Prefer the simplest clean-code solution that fits the existing architecture.
- If the FD is underspecified, propose the best default design choice instead of
  only asking questions.
- Ask questions only when implementation would be unsafe without the answer.
- Keep the output focused on readiness, not general project context.
- Do not include a broad project overview, directory tour, or recent-commit
  summary unless it directly explains a readiness issue.

## Working Directory

Use the current working directory as the project root.
