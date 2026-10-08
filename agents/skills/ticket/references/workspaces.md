# Operate a Feature Stack in One Herdr Workspace

By default, each feature uses one linked Git worktree and one Herdr workspace.
Each ticket owns one branch and one PR. For a stacked feature, work on its
branches in that worktree. Keep existing stacks with separate worktrees unless
the user requests migration. Shared planning stays in the origin checkout.

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
- At the planning checkpoint, provide the absolute ticket path, origin path, expected base, proposed branch, and feature workspace.
- For a new feature, the user may create the destination and start its agent. Otherwise use `fork` under the default isolation rule.
- Use the installed Herdr guidance and current CLI help for requested setup. Preserve user focus and existing work.

## Verify the implementation context

- Before coding or changing a PR, require the assigned feature's linked worktree and Herdr workspace.
- For work without a local ticket, use the agreed task or PR contract and keep its binding in the conversation. Do not invent a planning folder.
- Inspect the current branch, HEAD, index, and working tree before editing. Preserve unrelated changes and keep the step separate.
- Require `HERDR_ENV=1` and obtain the caller's `HERDR_WORKSPACE_ID`.
- Read `herdr workspace get <caller-workspace-id>` and parse its returned IDs and worktree metadata.
- Verify `result.workspace.worktree.is_linked_worktree` and match `checkout_path` to the current Git checkout.
- Resolve `repo_root` through the storage helper and verify that it shares the checkout's Git repository.
- Match the current branch and prerequisite code to the assessed ticket or agreed PR contract. Reassess material base changes before coding.
- Include agreed uncommitted prerequisites explicitly and reassess that context. Use the repository's stack workflow within the assigned context for stacked work.
- Before switching or creating a branch in a shared worktree, require a clean index and working tree. If either is dirty, stop.
- If another branch is checked out, use the `gh-stack` skill to select the ticket's branch. Then verify its branch and base.
- Bind an unassigned ticket to its branch and the verified feature worktree path and workspace ID in canonical metadata.
- For an existing binding, verify the path, workspace, and ticket branch. Verify changed session IDs through live metadata before refreshing them.
- Never use a feature workspace for an unrelated feature. Reviewers may use additional panes.
- If the required workspace is missing or mismatched, return the handoff and stop before coding or committing.
- Do not switch branches in the origin checkout to satisfy this requirement.

## Continue across tickets

- Keep all steps of a ticket on its assigned branch, with one approval checkpoint per commit.
- Read and revise canonical planning through absolute origin paths. Do not create local shadow copies.
- After a ticket completes, prepare the next ticket against its actual predecessor when requested.
- When continuing a shared-worktree stack, use `gh-stack` to select or create the ticket's branch. Before creating a branch, verify the current branch is its recorded predecessor.
- The agent requires the user's go before building that ticket.
- Leaving or removing a feature worktree does not remove the origin's planning files.
- Keep workspace cleanup and branch deletion outside this workflow unless explicitly requested.
