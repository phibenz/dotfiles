# Agent skills

Public skills live directly under `agents/skills`.

## Local-only skills

Put machine-local skills under `agents/skills.local`. The directory is ignored
by Git, and `agents/install.sh` discovers `SKILL.md` files recursively, so
grouping folders are supported:

```text
agents/skills.local/
└── company/
    └── internal-tool/
        ├── SKILL.md
        └── references/
```

Skill leaf-directory names must be unique. A local skill with the same name as
a public skill overrides the public skill when installed.

For content that should not live anywhere inside a Git worktree, set
`AGENTS_LOCAL_SKILLS_DIR` to an external directory before running the installer.
`.gitignore` protects against normal staging, but Git can still be forced to add
ignored files with `git add -f`.
