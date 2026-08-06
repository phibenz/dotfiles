#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS_DIR="${SCRIPT_DIR}/skills"
LOCAL_SKILLS_DIR="${AGENTS_LOCAL_SKILLS_DIR:-${SCRIPT_DIR}/skills.local}"
OLD_CODEX_SKILLS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)/codex/skills"
OLD_FD_SKILLS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)/codex/feature-design/skills"

mkdir -p "${LOCAL_SKILLS_DIR}"

skill_files=()
while IFS= read -r -d '' skill_file; do
  skill_files+=("${skill_file}")
done < <(find "${SOURCE_SKILLS_DIR}" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -print0)

# Local skills may be grouped in arbitrary subdirectories. Installing them last
# lets a local skill intentionally override a public skill with the same name.
while IFS= read -r -d '' skill_file; do
  skill_files+=("${skill_file}")
done < <(find "${LOCAL_SKILLS_DIR}" -mindepth 2 -name SKILL.md -type f -print0)

if [[ "$#" -eq 0 ]]; then
  target_dirs=("${HOME}/.agents/skills")
else
  target_dirs=("$@")
fi

installed=0
skipped=0
pruned=0

check_linearis_cli() {
  local linearis_cmd=""

  if command -v linearis >/dev/null 2>&1; then
    linearis_cmd="linearis"
  elif command -v linear >/dev/null 2>&1; then
    linearis_cmd="linear"
  else
    echo "Linearis CLI is required by the FD skills but was not found." >&2
    echo "Install it with: npm install -g linearis" >&2
    return 1
  fi

  if ! "${linearis_cmd}" usage >/dev/null; then
    echo "Linearis CLI failed: ${linearis_cmd} usage" >&2
    return 1
  fi

  if ! "${linearis_cmd}" issues usage >/dev/null; then
    echo "Linearis CLI failed: ${linearis_cmd} issues usage" >&2
    return 1
  fi

  echo "Linearis CLI ready: ${linearis_cmd}"
}

is_managed_skill_link() {
  local link_path="$1"
  local link_target

  link_target="$(readlink "${link_path}")"
  case "${link_target}" in
    "${SOURCE_SKILLS_DIR}"/*|"${LOCAL_SKILLS_DIR}"/*|"${OLD_CODEX_SKILLS_DIR}"/*|"${OLD_FD_SKILLS_DIR}"/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

source_skill_exists() {
  local skill_name="$1"
  local skill_file

  for skill_file in "${skill_files[@]}"; do
    if [[ "$(basename "$(dirname "${skill_file}")")" == "${skill_name}" ]]; then
      return 0
    fi
  done

  return 1
}

for target_dir in "${target_dirs[@]}"; do
  mkdir -p "${target_dir}"

  while IFS= read -r -d '' target_link; do
    skill_name="$(basename "${target_link}")"

    if source_skill_exists "${skill_name}"; then
      continue
    fi

    if is_managed_skill_link "${target_link}"; then
      rm "${target_link}"
      echo "Pruned stale skill ${skill_name} from ${target_dir}"
      pruned=$((pruned + 1))
    fi
  done < <(find "${target_dir}" -mindepth 1 -maxdepth 1 -type l -print0)

  for skill_file in "${skill_files[@]}"; do
    skill_dir="$(dirname "${skill_file}")"
    skill_name="$(basename "${skill_dir}")"
    target_link="${target_dir}/${skill_name}"

    if [[ -e "${target_link}" && ! -L "${target_link}" ]]; then
      echo "Skipping ${skill_name}: ${target_link} exists and is not a symlink"
      skipped=$((skipped + 1))
      continue
    fi

    ln -sfn "${skill_dir}" "${target_link}"
    echo "Linked ${skill_name} -> ${target_link}"
    installed=$((installed + 1))
  done
done

echo "Done. Linked ${installed} skill(s), pruned ${pruned}, skipped ${skipped}."

if [[ "$#" -eq 0 ]]; then
  "${SCRIPT_DIR}/install-open-source-skills.sh"
fi

check_linearis_cli
