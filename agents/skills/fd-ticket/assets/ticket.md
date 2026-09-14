## Objective

- <Concrete outcome this ticket must achieve.>

## Problem

- <The concrete problem this ticket solves.>

## Implementation Steps

- Each step represents one coherent commit containing its tests and production
  changes, with the relevant tests passing.
- Complete one behavior at a time: write a test, confirm the expected failure,
  implement that behavior, and confirm the tests pass before starting the next.

### 1. <Observable behavior>

- <One sentence explaining what behavior changes and why.>

#### Testing

- Test <concrete scenario> through <boundary> in `<test/path>`; expect
  <observable result>.

<Optional test sketch that clarifies the scenario or expected result.>

#### Implementation

- In `<production/path>`:
  - `<function or class>`: <required change and important constraints>.

<Optional implementation sketch that clarifies a contract or important
design choice. Use a signature, focused diff, or call-site example as appropriate.
Mark incomplete scaffolding and proposed additions clearly.>

- <Shared contract that dependent steps rely on, if any.>
