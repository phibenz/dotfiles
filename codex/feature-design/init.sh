#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT_ARG="${1:-}"

if [[ -z "${TARGET_ROOT_ARG}" ]]; then
  echo "Usage: $0 <project-path>" >&2
  exit 1
fi

TARGET_ROOT="${TARGET_ROOT_ARG}"

TARGET_ROOT="$(cd "${TARGET_ROOT}" && pwd)"
TARGET_DIR="${TARGET_ROOT}/docs/features"

INDEX_SRC="${SCRIPT_DIR}/FEATURE_INDEX.md"
TEMPLATE_SRC="${SCRIPT_DIR}/TEMPLATE.md"
INDEX_DST="${TARGET_DIR}/FEATURE_INDEX.md"
TEMPLATE_DST="${TARGET_DIR}/TEMPLATE.md"

if [[ ! -f "${INDEX_SRC}" || ! -f "${TEMPLATE_SRC}" ]]; then
  echo "Missing source templates in ${SCRIPT_DIR}" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

copy_file() {
  local src="$1"
  local dst="$2"

  if [[ -e "${dst}" ]]; then
    echo "Skipping existing file: ${dst}"
    return
  fi

  cp "${src}" "${dst}"
  echo "Wrote ${dst}"
}

copy_file "${INDEX_SRC}" "${INDEX_DST}"
copy_file "${TEMPLATE_SRC}" "${TEMPLATE_DST}"

echo "Feature design templates initialized in ${TARGET_DIR}"
