# Feature Workflow

Use three skills for routine work. The agent selects supporting skills as needed.

| Say | The agent does | Your checkpoint |
| --- | --- | --- |
| “Plan this feature.” | [plan](skills/plan/SKILL.md) drafts, compares designs, reviews, and revises the plan and next ticket. | Review the short summary and give the go before coding. |
| “Build this ticket.” | [build](skills/build/SKILL.md) implements one step, verifies it, and runs elegance review. | Review the diff, discuss changes, and approve one commit. |
| “Babysit this PR.” | [babysit](skills/babysit/SKILL.md) checks reviews and CI, validates claims, and prepares supported fixes and replies. | Review each fix and its reply drafts together before the commit. |

Plans and tickets stay local in the origin's `docs/work/0001-feature/` folder.
Each PR uses its own worktree and Herdr workspace.
The agent forks separate features and prerequisites into their own contexts.

You can authorize delivery once for a PR, for example:
“After I approve each fix, push it and post the reviewed replies.”
That authorization applies to later rounds for the same PR. Each commit still requires your approval.
Thread resolution and remote check reruns require authorization when you want those actions.

Use `outline`, `design`, `ticket`, `assess`, `verify`, `triage`, or `fork` directly for a focused task.
These supporting skills remain available for automatic selection.
Use `pr` for PR creation and `acp` for an explicit commit-and-push request.
