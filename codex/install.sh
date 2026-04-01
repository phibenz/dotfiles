#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SKILLS_DIR="${HOME}/.codex/skills"
TARGET_RULES_DIR="${HOME}/.codex/rules"

mkdir -p "${TARGET_SKILLS_DIR}"
mkdir -p "${TARGET_RULES_DIR}"

installed=0
skipped=0

while IFS= read -r -d '' skill_file; do
  skill_dir="$(dirname "${skill_file}")"
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
done < <(find "${SCRIPT_DIR}" -name SKILL.md -path '*/skills/*/SKILL.md' -type f -print0)

while IFS= read -r -d '' rule_file; do
  rule_name="$(basename "${rule_file}")"
  target_link="${TARGET_RULES_DIR}/${rule_name}"

  if [[ -e "${target_link}" && ! -L "${target_link}" ]]; then
    echo "Skipping ${rule_name}: ${target_link} exists and is not a symlink"
    skipped=$((skipped + 1))
    continue
  fi

  ln -sfn "${rule_file}" "${target_link}"
  echo "Linked ${rule_name} -> ${target_link}"
  installed=$((installed + 1))
done < <(find "${SCRIPT_DIR}/rules" -name '*.rules' -type f -print0)

echo "Done. Linked ${installed} item(s), skipped ${skipped}."
