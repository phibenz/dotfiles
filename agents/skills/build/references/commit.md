# Commit the Approved Step

Commit only the approved step. Preserve unrelated staged and unstaged work.

## Confirm approval and commit scope

- Approval of a `build` checkpoint authorizes one commit for that step.
- Inspect changes made since the checkpoint and verify affected behavior. If behavior or design changes, present the revised step for approval again.
- Inspect the full index and working tree before staging the approved paths or hunks.
- Exclude `docs/work/` planning files, reports, and local evidence from every commit, including forced or pre-existing staged entries.
- If the index contains no unrelated changes, stage only the approved scope and use the normal commit route.
- If the index contains unrelated changes in other paths, use `git commit --only -- <approved-paths>` with the usual subject and attribution.
- This route commits each named path's working-tree content. Use it only when every change in those paths belongs to the approved step.
- Verify that those paths contain the complete approved step, including new files, before committing.
- Do not use a whole-path commit when approved and unrelated changes share a path.
- If you discover mixed-path work later, preserve it and report the isolation problem before committing.
- Do not clear the original index or stash unrelated work to make the commit succeed.
- Apply this isolation rule before ACP's commit-and-push command. Keep its push target and failure handling unchanged.

## Create the commit and handle hooks

- Inspect the proposed commit diff and confirm that it contains the complete approved step and no unrelated changes.
- Create one conventional commit with active-model co-author attribution. Keep configured commit hooks enabled.
- If a hook fails, report the failure and do not start another step or bypass it.
- Verify formatting corrections before retrying. For behavior or design corrections, return to the `build` checkpoint before retrying.
- When using ACP, also keep its repair eligibility and one-retry limit. A successful commit followed by a failed push remains a completed local commit.
- After the commit, inspect its diff and verify that unrelated staged and unstaged changes remain intact.
