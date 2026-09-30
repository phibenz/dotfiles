# Review Significant Contracts Independently

Use a separate read-only reviewer for significant shared contracts introduced or changed during planning or implementation.
Self-review does not satisfy this requirement.

## Select the review scope

- Require this review when a shared contract changes supported inputs, outputs, ownership, lifecycle, failure behavior, or compatibility.
- Include consequential initial designs that establish such contracts across steps or tickets.
- Renames that preserve behavior and do not change dependent assumptions need only the ordinary review pass.
- Review the changed contract and affected dependents, including indirect dependents.

## Give the reviewer the evidence

- Start a fresh reviewer with no role in drafting the design or implementing the change.
- Ask it to use [assess](../SKILL.md) for the combined plan, ticket, and changed-contract scope as applicable.
- Give it the agreed outcome, constraints, implementation base, draft paths, and relevant code or diff paths.
- Include the prior contract, candidate designs when present, and verification recipes.
- Let the reviewer inspect the evidence directly. Do not prescribe the expected verdict.
- Limit the reviewer to read-only operations and prohibit publication or commits.
- Ask it to assess contract correctness, caller impact, dependent assumptions, and whether verification can detect a violation.
- Require evidence, consequence, and a supported resolution for each material finding.

## Resolve and record the result

- The drafting agent decides which findings to accept or reject using the evidence.
- Correct accepted findings within the agreed scope and obtain review of the affected revisions.
- Record the reviewer, reviewed scope and revision, material findings, and their disposition in the local review report.
- A later significant contract revision requires a new assessment of the changed scope.
- For implementation changes, finish independent review before presenting the step as ready for approval.
- If delegation is unavailable or prohibited, report that independent review remains blocked.
- Continue unaffected planning when useful. Do not declare affected work ready or code its dependents before this review completes.
