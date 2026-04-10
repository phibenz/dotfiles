# Git Hooks

This directory contains reusable `pre-commit` templates.

## Python project

Copy the config into a repo:

```bash
cp ~/projects/dotfiles/git/pre-commit-config.python.yaml .pre-commit-config.yaml
```

Install `pre-commit`:

```bash
uv tool install pre-commit
```

Install the Git hook in that repo:

```bash
pre-commit install
```

Run it once across all files:

```bash
pre-commit run --all-files
```

The config includes basic file hygiene checks plus:

- trailing whitespace cleanup
- end-of-file cleanup
- JSON / TOML / YAML validation
- merge-conflict / case-conflict checks
- `ruff check --fix` with line length set to `100`
- `ruff format` with line length set to `100`
- `uv run ty check`

If you use `uv`, add `ty` to the project:

```bash
uv add --dev ty
```
