#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_AGENTS_FILE="$(cd "${SCRIPT_DIR}/.." && pwd)/agents/AGENTS.md"
TARGET_AGENTS_FILE="${HOME}/.codex/AGENTS.md"
TARGET_RULES_DIR="${HOME}/.codex/rules"
SOURCE_PROFILE="${SCRIPT_DIR}/dotfiles.config.toml"
TARGET_PROFILE="${HOME}/.codex/dotfiles.config.toml"
CODEX_INSTALL_URL="https://chatgpt.com/codex/install.sh"
CODEX_BIN_DIR="${CODEX_INSTALL_DIR:-${HOME}/.local/bin}"
CODEX_BIN="${CODEX_BIN_DIR}/codex"

mkdir -p "${TARGET_RULES_DIR}"

installed=0
skipped=0

if [[ ! -x "${CODEX_BIN}" ]]; then
  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install Codex." >&2
    exit 1
  fi

  echo "Installing Codex CLI with the standalone installer..."
  curl -fsSL "${CODEX_INSTALL_URL}" | \
    CODEX_NON_INTERACTIVE=1 CODEX_INSTALL_DIR="${CODEX_BIN_DIR}" sh
fi

if [[ ! -x "${CODEX_BIN}" ]]; then
  echo "Codex CLI is not executable after installation: ${CODEX_BIN}" >&2
  exit 1
fi

echo "Codex CLI ready: ${CODEX_BIN}"

if [[ -e "${TARGET_AGENTS_FILE}" && ! -L "${TARGET_AGENTS_FILE}" && -s "${TARGET_AGENTS_FILE}" ]]; then
  echo "Skipping Codex instructions: ${TARGET_AGENTS_FILE} exists and is not a symlink"
  skipped=$((skipped + 1))
else
  ln -sfn "${SOURCE_AGENTS_FILE}" "${TARGET_AGENTS_FILE}"
  echo "Linked Codex instructions -> ${TARGET_AGENTS_FILE}"
  installed=$((installed + 1))
fi

while IFS= read -r -d '' rule_file; do
  rule_name="$(basename "${rule_file}")"
  target_file="${TARGET_RULES_DIR}/${rule_name}"

  if [[ -L "${target_file}" ]]; then
    rm "${target_file}"
  elif [[ -e "${target_file}" && ! -f "${target_file}" ]]; then
    echo "Skipping ${rule_name}: ${target_file} exists and is not a regular file"
    skipped=$((skipped + 1))
    continue
  fi

  cp "${rule_file}" "${target_file}"
  echo "Installed ${rule_name} -> ${target_file}"
  installed=$((installed + 1))
done < <(find "${SCRIPT_DIR}/rules" -name '*.rules' -type f -print0)

if [[ -e "${TARGET_PROFILE}" && ! -L "${TARGET_PROFILE}" ]]; then
  echo "Skipping Codex profile: ${TARGET_PROFILE} exists and is not a symlink"
  skipped=$((skipped + 1))
else
  ln -sfn "${SOURCE_PROFILE}" "${TARGET_PROFILE}"
  echo "Linked Codex profile -> ${TARGET_PROFILE}"
  installed=$((installed + 1))
fi

echo "Done. Linked ${installed} Codex item(s), skipped ${skipped}."
