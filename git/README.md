# Git Setup and Hooks

Configure global Git identity and credential caching:

```bash
bash ~/projects/dotfiles/git/install.sh
```

The script prompts for a missing `user.name`, then a missing `user.email`.
It sets `credential.helper` to `cache --timeout=3600` if no global helper is
configured. Existing global settings are preserved, including helpers such as
Git Credential Manager or a system keychain.

## Git hooks

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
