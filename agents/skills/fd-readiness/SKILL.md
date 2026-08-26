---
name: fd-readiness
description: Review one Linear implementation ticket against the current codebase and decide whether it is ready for one focused pull request. Trigger for issue identifiers such as FD-012 when the user wants blockers, ambiguities, unresolved questions, and recommended clean-code resolutions before implementation. Do not use to assess a parent feature plan as one implementation unit.
---

# Linear Ticket Readiness Review

Evaluate whether one Linear implementation ticket is ready for one focused pull
request against the current repository state. Surface only the ambiguities,
blockers, unresolved decisions, scope problems, and code-path risks that must be
resolved before implementation starts.

## Argument

Required: a Linear issue id such as `FD-012` or another uppercase prefix plus
number.

Optional: a focus area, such as `API shape`, `migration path`, `tests`, or
`implementation plan`.

If the argument does not include an issue id token matching
`[A-Z][A-Z0-9]*-[0-9]+`, ask the user to provide it before continuing.

## Linearis Runtime

The agent skill installer validates that the Linearis CLI exists and supports
the required issue commands. Do not repeat that preflight for every readiness
request. Use `linearis` when available; otherwise use the supported `linear`
alias.

Run Linearis authentication checks and issue commands with network access
outside the sandbox. If a sandboxed `auth status` reports
`authenticated: false`, retry with network access before treating the token as
invalid.

If Linearis is missing, exits with an authentication-required JSON error, or
exits with code 42, stop and surface the setup or auth instruction to the user.
Do not install or authenticate automatically because those flows are
environment-specific and may be interactive.

## Review Goal

Answer the practical question:

> Can we start implementing this ticket safely now, and if not, what exactly
> needs clarification or design adjustment?

Prefer concise, repo-grounded findings over exhaustive background. Do not
summarize the whole project unless a project constraint directly affects
readiness.

## Investigation Steps

1. Identify the implementation root.
   - Use the current working directory's git repo root as the implementation
     root.
   - Keep this root fixed for code inspection, branch/diff checks, command
     examples, and interpreting repo-relative paths from the Linear ticket.

2. Read the target Linear ticket.
   - Use Linearis to read the issue identified by the requested id.
   - Use `## Summary` as quick context and the remaining description as the
     implementation contract.
   - If the issue is a parent feature plan with multiple implementation
     tickets, ask the user to select a child ticket. Do not rate the parent as
     one implementation unit.
   - Read issue discussions or replies only when the ticket body points to
     missing design decisions that may have been clarified there.
   - Do not update the ticket unless the user explicitly asks to persist the
     readiness review.

3. Extract only the implementation-relevant contract.
   - Objective and intended user-visible behavior.
   - Proposed architecture or code path.
   - Acceptance criteria and verification plan.
   - Files, modules, APIs, commands, schemas, or data paths the ticket names.
   - Interpret relative file paths in the ticket as relative to the
     implementation root unless the ticket explicitly says otherwise.
   - If the ticket contains an absolute path that points inside a different
     worktree for the same repository, translate it to the equivalent
     repo-relative path and inspect that path under the implementation root.
   - Treat absolute paths outside the repository as external dependencies or
     artifacts, not as implementation-root-relative code paths.

4. Trace the real code paths.
   - Inspect the referenced files and nearby implementations.
   - Follow entry points, call sites, config/schema boundaries, and tests.
   - Check whether the proposed code path actually exists.
   - Identify existing helpers or abstractions that should be reused.
   - Look for simpler alternatives that fit the current architecture better.

5. Check current repo state.
   - Current branch and diff against the likely base branch.
   - Relevant uncommitted work.
   - Recent commits only when they overlap the ticket scope.
   - In-flight changes that may conflict with the ticket.

6. Judge implementation readiness.
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
- Scope that contains more than one independent semantic change or pull request.
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
   Evidence: <specific ticket section, file, function, command, schema, or code path>
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
The ticket maps cleanly to existing code paths and the remaining decisions are
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
- If the ticket is underspecified, propose the best default design choice
  instead of only asking questions.
- Ask questions only when implementation would be unsafe without the answer.
- Keep the output focused on readiness, not general project context.
- Do not include a broad project overview, directory tour, or recent-commit
  summary unless it directly explains a readiness issue.

## Working Directory

Use the current working directory to identify the implementation checkout, then
use that checkout's git repository root as the implementation root.
