#!/usr/bin/env bash
# Validate and link Ghostty settings. Back up any existing configuration first.

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Skipping Ghostty configuration: this installer requires macOS."
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/config.ghostty"
TARGET_DIR="${HOME}/Library/Application Support/com.mitchellh.ghostty"
TARGET_FILE="${TARGET_DIR}/config.ghostty"

GHOSTTY_BIN="/Applications/Ghostty.app/Contents/MacOS/ghostty"
if [[ ! -x "${GHOSTTY_BIN}" ]]; then
    echo "ERROR: Install Ghostty in /Applications first." >&2
    exit 1
fi

"${GHOSTTY_BIN}" +validate-config --config-file="${SOURCE_FILE}"

mkdir -p "${TARGET_DIR}"
if [[ "${TARGET_FILE}" -ef "${SOURCE_FILE}" ]]; then
    echo "Ghostty configuration is already installed."
    exit 0
fi

if [[ -d "${TARGET_FILE}" && ! -L "${TARGET_FILE}" ]]; then
    echo "ERROR: Configuration target is a directory: ${TARGET_FILE}" >&2
    exit 1
fi

if [[ -e "${TARGET_FILE}" || -L "${TARGET_FILE}" ]]; then
    backup_dir="$(mktemp -d "${TARGET_DIR}/dotfiles-backup.XXXXXX")"
    mv "${TARGET_FILE}" "${backup_dir}/config.ghostty"
    echo "Previous configuration saved to: ${backup_dir}/config.ghostty"
fi
ln -s "${SOURCE_FILE}" "${TARGET_FILE}"

if [[ -e "${TARGET_DIR}/config" ]]; then
    echo "Warning: ${TARGET_DIR}/config loads later and can override these settings."
fi

echo "Ghostty configuration installed. Press Cmd+Shift+, in Ghostty to reload."
