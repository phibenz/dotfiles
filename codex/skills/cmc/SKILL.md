---
name: cmc
description: Generate the same staged-change commit message as cm, with Codex model co-author attribution, then run git commit with that message. Use when the user asks for $cmc, cmc, or to commit staged changes with a generated message.
---

# Commit Staged Changes

Use the shared `cm` skill workflow to generate the commit message:

```text
<prefix>: <message>

Co-authored-by: <model> <noreply@openai.com>
```

Then create the commit with that message:

```sh
git commit -m "<subject>" -m "Co-authored-by: <model> <noreply@openai.com>"
```

Forward any user-provided `git commit` flags such as `--amend` or
`--no-verify`.

If there is no staged diff, stop and say `no staged changes`.
