#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS_DIR="${SCRIPT_DIR}/feature-design/skills"
TARGET_SKILLS_DIR="${HOME}/.codex/skills"

if [[ ! -d "${SOURCE_SKILLS_DIR}" ]]; then
  echo "No skills directory found at: ${SOURCE_SKILLS_DIR}" >&2
  exit 1
fi

mkdir -p "${TARGET_SKILLS_DIR}"

installed=0
skipped=0

while IFS= read -r -d '' skill_dir; do
  skill_name="$(basename "${skill_dir}")"

  if [[ "${skill_name}" == "." || "${skill_name}" == ".." ]]; then
    continue
  fi

  target_link="${TARGET_SKILLS_DIR}/${skill_name}"

  if [[ -e "${target_link}" && ! -L "${target_link}" ]]; then
    echo "Skipping ${skill_name}: ${target_link} exists and is not a symlink"
    skipped=$((skipped + 1))
    continue
  fi

  ln -sfn "${skill_dir}" "${target_link}"
  echo "Linked ${skill_name} -> ${target_link}"
  installed=$((installed + 1))
done < <(find "${SOURCE_SKILLS_DIR}" -mindepth 1 -maxdepth 1 -type d -print0)

echo "Done. Linked ${installed} skill(s), skipped ${skipped}."
