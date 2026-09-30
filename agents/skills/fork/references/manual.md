# Set Up Manually or Recover an Incomplete Fork

Read this reference for an existing destination, explicit startup settings, or a failed setup.
Keep the source objective and work intact. Setup does not grant permission to code or publish.

## Manual setup

- Use this route for an existing destination or required explicit startup settings. Do not run the script for this route.
- If the destination does not exist, use `herdr worktree create` with explicit origin context, branch, base, path, label, and `--no-focus`.
- Parse the returned workspace and pane IDs. For an existing destination, obtain these IDs from its live metadata.
- Verify the linked checkout, branch, and base. Preserve any existing destination that conflicts with the handoff.
- Split the destination into top and bottom panes with `--direction down` unless that layout already exists.
- Keep the agent in the original top pane and leave the bottom pane available. Reuse a verified existing fork instead of starting another agent.
- For Codex, verify the installed `codex fork --help` syntax before startup.
- Read the destination's terminal output before startup. Keep that snapshot to distinguish new update messages from old output.
- Start the fork through `herdr agent start` in the destination's available top pane.
- Use an explicit session ID and destination directory:

```text
herdr agent start <name> --kind codex --pane <destination-pane-id> -- fork <source-session-id> -C <destination-worktree>
```

- Do not use `--last`, resume the original session, or use `/fork` in the source pane for this handoff.
- Herdr already creates the checkout. Do not also request Codex's `--worktree` option.
- Apply the same verified source settings when explicit startup options are necessary.
- After startup, verify the new session has a distinct ID and uses the destination checkout.
- Verify the destination's Herdr context before submitting its handoff through `herdr agent prompt`.
- The handoff explicitly replaces the active objective and says to plan only until the reviewed checkpoint, unless ticket implementation already has approval.

## Recover incomplete setup

- Inspect the script's state file or the conversation record before recovery. Do not rerun setup blindly with another state file.
- If startup or prompt submission fails, inspect the created workspace, pane, and agent before retrying.
- Codex can update during startup and exit with `Update ran successfully! Please restart Codex.` instead of starting the conversation.
- Before manual recovery, inspect the setup state or conversation record. If an update restart already occurred, stop and report its failure.
- Require a new update-success message from that failed startup. Old terminal output does not authorize a restart.
- Verify the original top pane and workspace through live metadata. Require no active agent and the shell PID as the only foreground process.
- Confirm that this pane returned to its interactive shell prompt. Record the one restart in setup state or the conversation before execution.
- Then restart the exact fork command once in that pane, preserving the source session, destination, model, and approved access options.
- Reuse the worktree, workspace, and pane. Verify the new session before submitting the handoff. Stop if the restart fails.
- Do not start duplicate agents after a timeout. Report the exact completed and pending setup stages.
