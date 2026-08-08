#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI is required by the gh-stack skill but was not found." >&2
  echo "Install it from: https://cli.github.com" >&2
  exit 1
fi

if ! gh extension list | grep -Fq "github/gh-stack"; then
  gh extension install github/gh-stack
fi

open_source_skills=(
  "addyosmani/agent-skills@documentation-and-adrs"
  "github/gh-stack"
  "linearis-oss/linearis"
)

for skill in "${open_source_skills[@]}"; do
  npx --yes skills add "${skill}" \
    --global \
    --agent claude-code \
    --agent codex \
    --yes
done
