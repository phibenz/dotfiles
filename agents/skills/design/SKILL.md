---
name: design
description: Compare consequential software designs and propose the smallest complete contract. Use for requests to design an interface, compare architectures, or settle data shapes and ownership before coding. Return a proposal. Use assess for independent review and plan for the complete planning workflow.
---

# Design the Contract

Return a design proposal grounded in required behavior, caller usage, and current code.
Keep ticket writing and implementation with the calling workflow.

## Establish the constraints

- Read the requested outcome, relevant code, callers, and any existing design decisions.
- Establish scope, compatibility promises, and explicit exclusions.
- Start from caller usage. Derive interfaces, data shapes, and ownership from that evidence.
- Treat shared interfaces, ownership, lifecycle, persistence, and compatibility choices as consequential.
- For routine changes, explain the existing pattern briefly instead of inventing alternatives.

## Compare and choose

- For unresolved consequential choices, sketch at least two structurally different candidates.
- Show caller usage and the data or ownership shape for each candidate.
- Compare the same constraints, correctness risks, maintenance cost, and verification path.
- Resolve disputed behavior through current code or a small, isolated experiment when useful.
- Keep experiments within execution permissions and preserve existing work.
- Choose the smallest complete design that meets the agreed contract.
- If repeated fixes fail under one premise, reconsider that premise before proposing more machinery.
- Resolve ordinary technical choices from evidence. Ask about decisions that change the agreed outcome, scope, or compatibility promises.

## Return the proposal

- State the chosen contract and why it meets the constraints.
- For consequential choices, name the strongest rejected alternative and the evidence or tradeoff that ruled it out.
- Include caller sketches, dependent assumptions, and how verification can detect contract violations.
- Return unresolved decisions and evidence limits when they remain.
- Keep the rationale short enough to carry into the ticket's Design Rationale.
- Reuse an existing rationale when the design and relevant constraints remain valid.
- The calling writer records shared decisions in the parent plan and references them from affected tickets.
- A proposal does not establish implementation readiness. Coordinators obtain assessment and required independent review through [assess](../assess/SKILL.md).
- Do not implement, commit, publish, or replace ticket drafts as part of this skill.
