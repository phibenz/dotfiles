#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_SKILLS_DIR="${SCRIPT_DIR}/skills"
LOCAL_SKILLS_DIR="${AGENTS_LOCAL_SKILLS_DIR:-${SCRIPT_DIR}/skills.local}"

mkdir -p "${LOCAL_SKILLS_DIR}"
LOCAL_SKILLS_DIR="$(cd "${LOCAL_SKILLS_DIR}" && pwd)"

# Recognize managed links from every registered checkout of this repository.
checkout_skill_roots=("${LOCAL_SKILLS_DIR}")
while IFS= read -r -d '' record; do
  case "${record}" in
    "worktree "*)
      checkout="${record#worktree }"
      checkout_skill_roots+=(
        "${checkout}/agents/skills"
        "${checkout}/agents/skills.local"
        "${checkout}/codex/skills"
        "${checkout}/codex/feature-design/skills"
      )
      ;;
  esac
done < <(git -C "${REPO_DIR}" worktree list --porcelain -z)
checkout_skill_roots+=("${SOURCE_SKILLS_DIR}")

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
  # Refresh client directories too, including existing direct Codex skill links.
  target_dirs=("${HOME}/.agents/skills" "${HOME}/.codex/skills" "${HOME}/.claude/skills")
else
  target_dirs=("$@")
fi

installed=0
pruned=0

# Add one owned source root without growing the record on repeated installs.
remember_skill_root() {
  local root="$1"
  local existing

  for existing in "${managed_skill_roots[@]}"; do
    if [[ "${existing}" == "${root}" ]]; then
      return 0
    fi
  done
  managed_skill_roots+=("${root}")
}

# Match links against the recorded source directories.
is_managed_skill_link() {
  local link_path="$1"
  local link_target
  local root

  link_target="$(readlink "${link_path}")"
  for root in "${managed_skill_roots[@]}"; do
    case "${link_target}" in
      "${root}"/*) return 0 ;;
    esac
  done
  return 1
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
  target_dir="$(cd "${target_dir}" && pwd)"
  roots_file="${target_dir}/.dotfiles-managed-skill-roots"
  managed_skill_roots=("${SOURCE_SKILLS_DIR}")
  if [[ -L "${roots_file}" || ( -e "${roots_file}" && ! -f "${roots_file}" ) ]]; then
    echo "Cannot update skill ownership record: ${roots_file}" >&2
    exit 1
  fi
  if [[ -f "${roots_file}" ]]; then
    while IFS= read -r -d '' root; do
      remember_skill_root "${root}"
    done < "${roots_file}"
  fi
  for root in "${checkout_skill_roots[@]}"; do
    remember_skill_root "${root}"
  done

  # Retain ownership before linking, even if installation later stops.
  roots_temp="$(mktemp "${roots_file}.XXXXXX")"
  printf '%s\0' "${managed_skill_roots[@]}" > "${roots_temp}"
  mv -f "${roots_temp}" "${roots_file}"

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
      echo "Cannot install ${skill_name}: ${target_link} exists and is not a symlink" >&2
      exit 1
    fi

    ln -sfn "${skill_dir}" "${target_link}"
    echo "Linked ${skill_name} -> ${target_link}"
    installed=$((installed + 1))
  done
done

echo "Done. Linked ${installed} skill(s), pruned ${pruned}."

if [[ "$#" -eq 0 ]]; then
  "${SCRIPT_DIR}/install-open-source-skills.sh"
fi
