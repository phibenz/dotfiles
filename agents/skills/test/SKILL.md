---
name: test
description: Write or review automated tests that maximize confidence relative to maintenance cost. Use when adding, selecting, restructuring, or removing tests, or when deciding test boundaries, test doubles, TDD workflow, or the test portfolio. Do not use only to run an existing test command without changing or assessing tests.
---

# Effective Testing

Create self-testing code that gives useful feedback and supports change. Treat
TDD as one technique, not as the goal or a universal requirement.

Read [references/examples.md](references/examples.md) when a test's boundary,
expected value, use of doubles, or test level is unclear. Use the examples as
decision aids, not as fixed templates.

## Establish the Contract

- Follow repository instructions, existing test conventions, and the supported
  public behavior.
- Inspect nearby production code and tests before selecting a test boundary.
- Identify the behavior, plausible regression, or nontrivial invariant that
  each test will protect.
- Select a stable boundary where the behavior can be observed. Prefer a public
  interface over private implementation details.
- Ask the user about the boundary only when the choice changes public design,
  scope, or significant cost.
- If the user requested only a review or diagnosis, report findings without
  editing code.

## Choose the Feedback

Choose the cheapest test that provides sufficient confidence for the risk.
Consider these tradeoffs:

- **Frequency:** How quickly and often can the test give feedback?
- **Fidelity:** How accurately does it represent the behavior at risk?
- **Overhead:** What execution and maintenance cost does it add?
- **Lifespan:** How long and how critically must the behavior remain correct?

Prefer focused tests because they usually run quickly and isolate failures.
Use broader tests when only a broader boundary provides enough confidence, or
when those tests are fast, reliable, and inexpensive.

Do not enforce fixed ratios between unit, integration, and end-to-end tests.
Those labels vary between teams. Judge each test by its feedback and cost.

## Write Valuable Tests

- Test observable behavior, not internal structure. A behavior-preserving
  refactor should usually leave the test unchanged.
- Make each test read as a small specification in the project's domain
  language.
- Use expected values from an independent source, such as a specification,
  worked example, protocol, or known-good literal.
- Do not recompute the expected value with the same logic as the implementation.
  Such a test can pass while both sides contain the same defect.
- Cover important success paths, failure paths, boundaries, state transitions,
  integration contracts, and reproduced regressions.
- Make failures identify the broken behavior. Avoid tests that can fail for many
  unrelated environmental or setup reasons.
- Keep tests deterministic. Control time, randomness, process state, and
  external resources when they would make results unstable.
- Keep tests independent. Each test should pass alone and in any order. Support
  parallel execution when the repository expects it.
- Do not test trivial accessors, framework behavior, or library behavior unless
  the project adds a supported contract or meaningful integration risk.
- Do not add tests only to increase coverage. Coverage can reveal gaps, but it
  does not measure confidence or test quality.

## Use TDD When It Helps

TDD often helps when behavior is clear, examples are available, or a bug can be
reproduced. Exploratory work, visual behavior, or difficult integrations can
need a different feedback loop.

When using TDD, work in vertical slices:

1. Write one test for one observable behavior.
2. Run it and confirm that it fails for the expected reason.
3. Write the smallest complete implementation that makes it pass.
4. Refactor the code and test while the suite remains green.
5. Repeat with the next behavior learned from the previous slice.

Do not write every imagined test before implementation. Do not add speculative
production behavior for future tests. If implementation already exists, add a
regression or characterization test when it provides useful confidence; do not
delete working code merely to recreate a test-first sequence.

## Use Test Doubles Deliberately

Prefer real collaborators when they are fast, deterministic, and safe. Use a
fake, stub, or mock when it improves the feedback tradeoff at an external,
slow, unsafe, or difficult-to-reproduce boundary.

- Avoid mocking private collaborators or mirroring the implementation's call
  sequence.
- Verify outcomes and state through the selected boundary. Verify interactions
  only when the interaction itself is part of the supported contract.
- Keep fakes and stubs compatible with the real collaborator's contract.
  Prefer shared contract tests for important doubles; incomplete responses can
  hide integration defects.
- Do not add layers or indirection only to permit isolated tests. Accept that
  isolation has a design and maintenance cost.
- Use a sociable test with real collaborators when it gives useful confidence
  at reasonable cost. Use a solitary test when isolation gives clearer or
  faster feedback without distorting the design.

## Maintain the Test Portfolio

- When a broad test finds a defect, add a focused regression test when it can
  reproduce the same risk more clearly and cheaply.
- Keep the broad test only when it protects a distinct integration or system
  risk.
- Remove or rewrite redundant, brittle, tautological, or unsupported-history
  tests that add no distinct confidence or communication value.
- Do not add a tombstone test solely to prove that deleted, unsupported
  behavior remains absent. Remove tests for deleted functionality with that
  functionality. Keep or add a negative test only when the absence is itself a
  supported contract, security or safety invariant, compatibility boundary, or
  plausible recurring defect.
- Fix flaky tests by removing their cause. Do not hide instability with sleeps,
  retries, or weaker assertions unless the underlying behavior requires them.
- Treat repeated skips, unexplained expected failures, retry-only fixes, and
  commented-out tests as suite health problems. Fix, remove, or report them.
- Treat the suite as insufficient when developers cannot change the code with
  confidence.
- Treat the suite as excessive when routine behavior changes require more work
  in tests than in production code without buying distinct confidence.

## Verify and Report

- When reviewing tests, require correction when a test cannot detect a material
  violation of its protected behavior, relies on uncontrolled nondeterminism,
  or fails after an acceptable refactor without protecting a contract.
- Separate correctness findings from optional preferences about names,
  structure, test level, assertion count, doubles, or consolidation.
- For an important new test, confirm that it fails for the intended reason
  before accepting it. Prefer a natural red state. When working code predates
  the test and sensitivity is uncertain, use one small reversible mutation,
  confirm red, restore the code, and confirm green. Do not mutate when safe
  restoration is uncertain or the cost outweighs the evidence.
- Run the new or changed test in isolation first.
- Run the smallest relevant surrounding suite next.
- Run broader checks when the risk, repository instructions, or user request
  requires them.
- Report what ran, what passed, and what could not run. Do not present blocked
  checks as successful verification.

## Sources

This skill adapts ideas from:

- [Matt Pocock's TDD skill](https://github.com/mattpocock/skills/tree/main/skills/engineering/tdd)
- [Is TDD Dead?](https://martinfowler.com/articles/is-tdd-dead/)
- [Test Pyramid](https://martinfowler.com/bliki/TestPyramid.html)
- [On the Diverse And Fantastical Shapes of Testing](https://martinfowler.com/articles/2021-test-shapes.html)
