#!/usr/bin/env bash
set -euo pipefail

base_ref="origin/main"
linear_id=""
task=""
dry_run=0
mode="create"
positional=()

usage() {
  cat <<'USAGE'
Usage: worktree-tmux.sh [--linear-id ID] [--base REF] [--dry-run] <task-slug>
       worktree-tmux.sh [--base REF] [--dry-run] RL-1234 <task-slug>
       worktree-tmux.sh rm [--dry-run] [RL-1234] <task-slug>
       worktree-tmux.sh rm [--dry-run] RL-1234

Creates ../<repo>-<linear-id>-<task-slug>, branch
phil/<linear-id>/<task-slug> when an ID is provided, then opens a new tmux
window in that worktree with three panes. Without an ID, creates
../<repo>-<task-slug>, branch phil/<task-slug>.

The rm mode removes the matching worktree and kills the tmux window named after
the task slug.
USAGE
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    rm|remove|delete)
      if [[ "${#positional[@]}" -eq 0 && "${mode}" == "create" ]]; then
        mode="remove"
        shift
        continue
      fi
      positional+=("$1")
      shift
      ;;
    --base)
      base_ref="${2:?missing value for --base}"
      shift 2
      ;;
    --linear-id)
      linear_id="${2:?missing value for --linear-id}"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --rm|--remove|--delete)
      mode="remove"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      positional+=("$@")
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      positional+=("$1")
      shift
      ;;
  esac
done

if [[ "${mode}" == "remove" && -z "${linear_id}" && "${#positional[@]}" -eq 1 && "${positional[0]}" =~ ^[A-Za-z]+-[0-9]+$ ]]; then
  linear_id="${positional[0]}"
elif [[ "${mode}" == "remove" && -n "${linear_id}" && "${#positional[@]}" -eq 0 ]]; then
  task=""
elif [[ -z "${linear_id}" && "${#positional[@]}" -eq 2 && "${positional[0]}" =~ ^[A-Za-z]+-[0-9]+$ ]]; then
  linear_id="${positional[0]}"
  task="${positional[1]}"
elif [[ "${#positional[@]}" -eq 1 ]]; then
  task="${positional[0]}"
else
  echo "Task must be one dash-separated argument, for example: add-panel" >&2
  exit 2
fi

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
}

shell_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

run() {
  if [[ "${dry_run}" -eq 1 ]]; then
    printf '+'
    for arg in "$@"; do
      printf ' %s' "$(shell_quote "${arg}")"
    done
    printf '\n'
  else
    "$@"
  fi
}

repo_root="$(git rev-parse --show-toplevel)"
repo_parent="$(dirname "${repo_root}")"
origin_url="$(git -C "${repo_root}" config --get remote.origin.url || true)"

if [[ -n "${origin_url}" ]]; then
  repo_name="${origin_url##*/}"
  repo_name="${repo_name##*:}"
  repo_name="${repo_name%.git}"
else
  repo_name="$(basename "${repo_root}")"
fi

if [[ -n "${linear_id}" ]]; then
  branch_id="$(slugify "${linear_id}")"
else
  branch_id=""
fi

resolve_task_from_linear_id() {
  local current_branch=""
  local current_path=""
  local line
  local -a matches=()
  local -a match_paths=()
  local i

  while IFS= read -r line || [[ -n "${line}" ]]; do
    if [[ "${line}" == worktree\ * ]]; then
      current_path="${line#worktree }"
      current_branch=""
    elif [[ "${line}" == branch\ refs/heads/phil/"${branch_id}"/* ]]; then
      current_branch="${line#branch refs/heads/phil/"${branch_id}"/}"
    elif [[ -z "${line}" ]]; then
      if [[ -n "${current_branch}" ]]; then
        matches+=("${current_branch}")
        match_paths+=("${current_path}")
      fi
      current_path=""
      current_branch=""
    fi
  done < <(git -C "${repo_root}" worktree list --porcelain; printf '\n')

  if [[ "${#matches[@]}" -eq 0 ]]; then
    echo "No worktree found for ${linear_id}." >&2
    exit 1
  fi

  if [[ "${#matches[@]}" -gt 1 ]]; then
    echo "Multiple worktrees found for ${linear_id}; pass the task slug too:" >&2
    for ((i = 0; i < "${#matches[@]}"; i++)); do
      echo "  ${matches[$i]} (${match_paths[$i]})" >&2
    done
    exit 1
  fi

  task_slug="${matches[0]}"
  worktree_path="${match_paths[0]}"
}

if [[ "${mode}" == "remove" && -z "${task}" && -n "${linear_id}" ]]; then
  resolve_task_from_linear_id
elif [[ ! "${task}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Task must be a lowercase dash-separated slug, for example: add-panel" >&2
  exit 2
else
  task_slug="${task}"
  if [[ -n "${branch_id}" ]]; then
    worktree_path="${repo_parent}/${repo_name}-${branch_id}-${task_slug}"
  else
    worktree_path="${repo_parent}/${repo_name}-${task_slug}"
  fi
fi

if [[ -n "${branch_id}" ]]; then
  branch_name="phil/${branch_id}/${task_slug}"
else
  branch_name="phil/${task_slug}"
fi

kill_task_window() {
  local target

  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux not found; removed worktree only: ${worktree_path}" >&2
    return 0
  fi

  if [[ -n "${TMUX:-}" || "${dry_run}" -eq 1 ]]; then
    if [[ "${dry_run}" -eq 1 ]]; then
      target='#{session_id}'
    elif ! target="$(tmux display-message -p '#{session_id}' 2>/dev/null)"; then
      echo "tmux session unavailable; removed worktree only: ${worktree_path}" >&2
      return 0
    fi
    target="${target}:=${task_slug}"
  else
    target="=${task_slug}"
  fi

  if [[ "${dry_run}" -eq 1 ]]; then
    run tmux kill-window -t "${target}"
  elif ! tmux kill-window -t "${target}" 2>/dev/null; then
    echo "No tmux window named ${task_slug} found." >&2
  fi
}

if [[ "${mode}" == "remove" ]]; then
  if [[ -e "${worktree_path}" ]]; then
    run git -C "${repo_root}" worktree remove "${worktree_path}"
  elif [[ "${dry_run}" -eq 1 ]]; then
    run git -C "${repo_root}" worktree remove "${worktree_path}"
  else
    echo "No worktree found at ${worktree_path}" >&2
  fi

  kill_task_window
  exit 0
fi

if [[ -e "${worktree_path}" ]]; then
  echo "Worktree path already exists: ${worktree_path}" >&2
  exit 1
fi

run git -C "${repo_root}" worktree add "${worktree_path}" -b "${branch_name}" "${base_ref}"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux not found; created worktree only: ${worktree_path}" >&2
  exit 0
fi

if [[ -z "${TMUX:-}" && "${dry_run}" -ne 1 ]]; then
  echo "Not inside tmux; created worktree only: ${worktree_path}" >&2
  exit 0
fi

if [[ "${dry_run}" -ne 1 ]] && ! tmux display-message -p '#{session_id}' >/dev/null 2>&1; then
  echo "tmux session unavailable; created worktree only: ${worktree_path}" >&2
  exit 0
fi

if [[ "${dry_run}" -eq 1 ]]; then
  window_id="@new-window"
  run tmux new-window -P -F '#{window_id}' -n "${task_slug}" -c "${worktree_path}"
  top_pane="${window_id}.0"
  bottom_pane="%bottom-pane"
  lower_right_pane="%lower-right-pane"

  run tmux split-window -v -P -F '#{pane_id}' -t "${top_pane}" -c "${worktree_path}"
  run tmux split-window -h -P -F '#{pane_id}' -t "${bottom_pane}" -c "${worktree_path}"
else
  window_id="$(tmux new-window -P -F '#{window_id}' -n "${task_slug}" -c "${worktree_path}")"
  top_pane="${window_id}.0"
  bottom_pane="$(tmux split-window -v -P -F '#{pane_id}' -t "${top_pane}" -c "${worktree_path}")"
  lower_right_pane="$(tmux split-window -h -P -F '#{pane_id}' -t "${bottom_pane}" -c "${worktree_path}")"
fi

run tmux send-keys -t "${top_pane}" nvim C-m
run tmux send-keys -t "${lower_right_pane}" codex C-m
run tmux select-pane -t "${lower_right_pane}"
