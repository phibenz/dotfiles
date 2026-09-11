#!/usr/bin/env bash
# Link Pi settings and shared instructions without replacing existing local files.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.pi/agent"

if ! command -v pi >/dev/null 2>&1; then
  echo "Pi is required. Install it with: npm install -g --ignore-scripts @earendil-works/pi-coding-agent" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

for name in settings.json AGENTS.md; do
  if [[ "${name}" == "AGENTS.md" ]]; then
    source_file="${SCRIPT_DIR}/../agents/AGENTS.md"
  else
    source_file="${SCRIPT_DIR}/${name}"
  fi
  target_file="${TARGET_DIR}/${name}"

  if [[ -e "${target_file}" || -L "${target_file}" ]]; then
    if [[ -L "${target_file}" && "$(readlink "${target_file}")" == "${source_file}" ]]; then
      echo "Already linked: ${target_file}"
    else
      echo "Skipped existing file: ${target_file}"
    fi
    continue
  fi

  ln -s "${source_file}" "${target_file}"
  echo "Linked ${source_file} -> ${target_file}"
done

echo "Pi discovers shared skills from ~/.agents/skills automatically."
