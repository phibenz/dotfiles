#!/usr/bin/env bash
# Link Pi settings with a backup, and preserve existing local instructions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.pi/agent"

if ! command -v pi >/dev/null 2>&1; then
  echo "Pi is required. Install it with: npm install -g --ignore-scripts @earendil-works/pi-coding-agent" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

for name in settings.json editor-cursor.json web-search.json AGENTS.md; do
  if [[ "${name}" == "AGENTS.md" ]]; then
    source_file="${SCRIPT_DIR}/../agents/AGENTS.md"
  else
    source_file="${SCRIPT_DIR}/${name}"
  fi
  target_file="${TARGET_DIR}/${name}"

  if [[ -e "${target_file}" || -L "${target_file}" ]]; then
    if [[ -L "${target_file}" && "$(readlink "${target_file}")" == "${source_file}" ]]; then
      echo "Already linked: ${target_file}"
      continue
    elif [[ "${name}" != "AGENTS.md" && ( -f "${target_file}" || -L "${target_file}" ) ]]; then
      backup_file="$(mktemp "${target_file}.backup.XXXXXX")"
      mv "${target_file}" "${backup_file}"
      echo "Backed up ${target_file} -> ${backup_file}"
    else
      echo "Skipped existing file: ${target_file}"
      continue
    fi
  fi

  ln -s "${source_file}" "${target_file}"
  echo "Linked ${source_file} -> ${target_file}"
done

pi update --extensions

echo "Pi discovers shared skills from ~/.agents/skills automatically."
