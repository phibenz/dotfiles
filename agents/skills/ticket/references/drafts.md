# Manage Local Planning Files

Keep one canonical planning folder in the origin checkout. PR worktrees share it through absolute paths.
Read [PR Workspaces](workspaces.md) for checkout identity and agent handoffs.

## Resolve and initialize storage

- The origin is the local repository checkout registered by Herdr, not the remote named `origin`.
- Prefer Herdr's `result.workspace.worktree.repo_root` when available. Verify that it shares the current Git repository.
- Use [work_store.py](../scripts/work_store.py) in `inspect` mode to resolve the origin and storage path without writing files.
- Pass an explicit `--origin` from established metadata when needed. Otherwise the helper uses the primary Git checkout.
- If the origin is ambiguous or unavailable, resolve it before writing. Do not create a substitute store in the PR worktree.
- Use the fixed root `<origin>/docs/work/` and one folder per feature, such as `0003-request-client`.
- Keep active feature folders at the root. Keep archived feature folders under `<origin>/docs/work/archive/`.
- Number new feature folders in increasing order, starting at `0001`. Pad numbers to at least four digits, such as `0012`.
- For a standalone ticket, use the same numbered folder format without a parent plan.
- Run the helper in `init` mode with `--feature <padded-number>-<slug>` before writing new planning files.
- Initialization creates the feature folder and `archive/` and adds `/docs/work/` to the shared Git `info/exclude` file.
- The helper preserves existing exclusions and verifies that Git ignores the folder.
- Resolve reported tracking or ignore conflicts before writing drafts. Do not force-add, silently untrack, or overwrite existing work.
- If filesystem access prevents writing the origin store, report the required access. Keep existing drafts at their canonical paths.

## Feature layout

```text
docs/work/0003-request-client/
  plan.md
  tickets/T0003.1-request-options.md
  tickets/T0003.2-cli-preview.md
  reviews/P0003.md
  evidence/
docs/work/archive/0002-old-feature/
```

- Store the parent plan as `plan.md` and implementation tickets as `tickets/<local-id>-<slug>.md`.
- Store review reports in `reviews/`. Create `evidence/` only when retained verification needs it.
- Keep title, local ID, origin path, feature path, worktree binding, and relations in local metadata outside the ticket description.
- Keep code paths relative to the assessed implementation checkout. Link canonical planning files through their absolute origin paths.
- Never copy or symlink the planning folder into PR worktrees.
- Planning files, review reports, and local evidence never enter commits. Verify this again when staging implementation work.
- Local exclusion keeps planning out of ordinary staging. Verify commit scope even for forced or pre-existing staged files.
- Move a whole feature folder to `archive/` when its work is canceled, dropped, or done. Keep its files and IDs intact.
- Keep a canceled ticket in its active feature folder while other work in that feature continues.
- When work resumes, move its folder back to the root before adding or revising drafts.

## Local IDs and revisions

- Use the exact padded number from the feature folder in every ID. Folder `0006-*` uses plan `P0006` and tickets `T0006.1`, `T0006.2`, and so on.
- Every ticket uses the child number, even without a plan or with only one ticket. Do not use `T0006`.
- Folder `0006-*` reserves `P0006` and `T0006.*`, even before drafts exist. The helper rejects another folder with base `0006`.
- Before assigning an ID, inspect active and archived feature folders and files, including IDs in parent ticket lists.
- The drafting coordinator selects IDs from the canonical store before invoking initialization. The helper does not allocate IDs.
- Choose one greater than the highest reserved base number. Never fill earlier gaps. If no number exists, start at `1`.
- Add tickets using one greater than the highest assigned child number in that feature folder.
- Never reuse or change assigned base or child numbers. Pad old short IDs to match their folder, updating filenames and references together. Keep canceled and superseded entries in their feature folder, including after archival.
- Keep a feature's folder stable when its title, ordering, or ticket boundaries change.
- When replacing tickets, retain their drafts or parent entries and record replacement IDs.
- Reuse the canonical files during revisions. Read the latest content before writing and preserve unrelated changes.
- Coordinate writers to the same feature. Serialize ID allocation and edits to shared plans rather than overwrite another agent's revisions.
