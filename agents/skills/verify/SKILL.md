---
name: verify
description: Run concrete verification for an implemented change or existing behavior and return evidence, failures, and limitations. Use for requests to verify behavior or run a ticket's verification recipe. Production corrections belong to build. Planning uses the recipe reference without execution.
---

# Verify the Behavior

Run the required checks and compare observed behavior with the agreed contract.
Return evidence to the caller. Keep production corrections with `build`.

## Select the recipe

- Read the requested behavior, current code or diff, and any ticket recipe.
- Identify the implementation revision and relevant local changes under verification.
- Use the existing recipe when it covers the contract and remains valid.
- If no recipe exists, derive one from the requested contract using [Define Verification Recipes](references/recipes.md).
- Distinguish runnable checks from planned commands, fixtures, or test code that do not exist yet.
- Report missing implementation or verification code as unrun work. Do not create it or claim a pass.
- Stay within the requested execution permissions. Report required but unavailable access as blocked.

## Run and retain evidence

- Exercise the named interface with the specified input and compare the observed result with the pass condition.
- Run checks against the current implementation after material corrections.
- Retain command output and any required response data or artifact paths.
- When using shared ticket storage, keep local evidence in the origin feature's `evidence/` folder. Keep commands rooted in the implementation worktree.
- Perform cleanup for resources this run creates, including after failed attempts. Preserve the evidence.
- If a recipe cannot detect the promised behavior, report the gap and propose a correction for the caller to review.
- Reuse credible evidence only when the code and execution conditions remain unchanged.
- Do not change production code, change tests, commit, or publish during verification.

## Return the result

- Report each required check as passed, failed, blocked, or unrun.
- State the observed result and link retained evidence when available.
- Identify failures, missing prerequisites, and limitations that prevent a complete verdict.
- Treat the behavior as verified only when all required checks pass with sufficient evidence.
- Distinguish a failed behavior check from an unavailable verification environment.
- Keep the chat result short. Retain detailed evidence in the existing validation artifact or caller's report.
- `build` applies material corrections and invokes verification again before the user's review checkpoint.
