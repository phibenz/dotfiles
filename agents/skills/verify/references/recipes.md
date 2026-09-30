# Define Verification Recipes

Define a repeatable recipe in each implementation step's Verification section.
The recipe must detect a material violation of the behavior that step promises.

## Define the recipe during planning

- Name the real interface or behavior under verification.
- Specify the command or existing verification skill, working directory, and concrete input or fixture.
- State the observable expected result and pass condition.
- Name required setup, configuration, or credentials only when relevant.
- Specify the evidence to retain, such as command output, response data, or an artifact path.
- Include cleanup only for resources the verification creates. Preserve the evidence after cleanup.
- Reuse a shared recipe by reference when it already covers the step's behavior.
- Select verification that matches the risk. A deterministic test can be the complete recipe when it covers the contract.
- Require a real integration or user path when isolated tests cannot prove the changed behavior.
- Do not require live or performance verification when the step introduces no risk that needs it.
- Mark commands, fixtures, or verification code that implementation still needs to add as planned.
- Inspect existing commands for validity when feasible. Do not claim that planned verification already passed.
