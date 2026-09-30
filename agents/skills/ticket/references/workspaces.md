# Operate Each PR in Its Own Herdr Workspace

Each implementation ticket owns one branch, one linked Git worktree, and one Herdr workspace.
All PR operations use that worktree. Shared planning stays in the origin checkout.

## Isolate feature objectives

- Before detailed planning or coding, verify which feature the current conversation and workspace own.
- When the user starts a new feature from the origin checkout, use [fork](../../fork/SKILL.md) to create its worktree, workspace, and conversation.
- Apply the same rule when another feature's worktree discovers a separate prerequisite or receives a new feature request.
- Brief discovery, dependency recording, and handoff preparation may occur in the source context.
- Detailed planning and implementation belong to the destination feature's context.
- Continue revisions for the same feature in its existing context. Do not fork each planning round, commit step, or routine design correction.
- For an accepted feature, this workflow authorizes the setup. Do not require the user to create the workspace manually.
- If the user already created the correct worktree and workspace, verify and use them.
- Keep the current objective unchanged when outsourcing a prerequisite. Record the dependency and mark affected readiness stale.
- Stop dependent coding until the prerequisite exists and the affected plan receives review against its actual code.
- Planning writes remain in the origin store, even when the planning agent operates in a linked worktree.

## Planning and handoff

- Planning may inspect the origin or predecessor code for discovery. Start new feature planning in its isolated context.
- Record the actual target or predecessor branch and assessed commit in the canonical ticket metadata.
- Keep uncreated worktree and workspace bindings explicitly unassigned. Do not invent IDs or readiness evidence.
- At the planning checkpoint, provide the absolute ticket path, origin path, expected base, and proposed branch for the new agent.
- The user may create the destination and start its agent. Otherwise use `fork` under the default isolation rule.
- At later ticket boundaries, use `fork` for the next PR's separate context when the user requests continued feature work.
- Use the installed Herdr guidance and current CLI help for requested setup. Preserve user focus and existing work.

## Verify the implementation context

- Before coding or changing a PR, require its dedicated linked worktree and Herdr workspace.
- For work without a local ticket, use the agreed task or PR contract and keep its binding in the conversation. Do not invent a planning folder.
- Inspect the current branch, HEAD, index, and working tree before editing. Preserve unrelated changes and keep the step separate.
- Require `HERDR_ENV=1` and obtain the caller's `HERDR_WORKSPACE_ID`.
- Read `herdr workspace get <caller-workspace-id>` and parse its returned IDs and worktree metadata.
- Verify `result.workspace.worktree.is_linked_worktree` and match `checkout_path` to the current Git checkout.
- Resolve `repo_root` through the storage helper and verify that it shares the checkout's Git repository.
- Match the branch and prerequisite code to the assessed ticket or agreed PR contract. Reassess material base changes before coding.
- Include agreed uncommitted prerequisites explicitly and reassess that context. Use the repository's stack workflow within the assigned context for stacked work.
- Bind an unassigned ticket to the verified worktree path, branch, and returned workspace ID in its canonical metadata.
- For an existing binding, verify the path and branch. Verify changed session IDs through live metadata before refreshing them.
- Never repurpose one PR's worktree or workspace for another ticket. Reviewers for that PR may use additional panes in its workspace.
- If the required workspace is missing or mismatched, return the handoff and stop before coding or committing.
- Do not switch branches in the origin checkout to satisfy this requirement.

## Continue across tickets

- Keep all steps of a ticket in its assigned PR worktree, with one approval checkpoint per commit.
- Read and revise canonical planning through absolute origin paths. Do not create local shadow copies.
- After a ticket completes, prepare the next ticket against its actual predecessor when requested.
- Present the reviewed next ticket and the handoff for a separate Herdr workspace and worktree.
- Fork into that context when the request includes continuing the feature. Preserve the next ticket's approval checkpoint.
- The new agent requires the user's go before building that ticket.
- Leaving or removing a PR worktree does not remove the origin's planning files.
- Keep workspace cleanup and branch deletion outside this workflow unless explicitly requested.
