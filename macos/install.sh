#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Skipping macOS settings: macOS is required."
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABEL="local.caps-lock-backspace"
SOURCE_AGENT="${SCRIPT_DIR}/${LABEL}.plist"
TARGET_AGENT_DIR="${HOME}/Library/LaunchAgents"
TARGET_AGENT="${TARGET_AGENT_DIR}/${LABEL}.plist"
DOMAIN="gui/$(id -u)"

if ! plutil -lint "${SOURCE_AGENT}" >/dev/null; then
  echo "ERROR: Invalid LaunchAgent: ${SOURCE_AGENT}" >&2
  exit 1
fi

mkdir -p "${TARGET_AGENT_DIR}"

if [[ -L "${TARGET_AGENT}" ]]; then
  rm "${TARGET_AGENT}"
elif [[ -e "${TARGET_AGENT}" && ! -f "${TARGET_AGENT}" ]]; then
  echo "ERROR: LaunchAgent target is not a regular file: ${TARGET_AGENT}" >&2
  exit 1
fi

install -m 0644 "${SOURCE_AGENT}" "${TARGET_AGENT}"

launchctl bootout "${DOMAIN}/${LABEL}" >/dev/null 2>&1 || true
launchctl bootstrap "${DOMAIN}" "${TARGET_AGENT}"

echo "Caps Lock now acts as Backspace."
echo "Installed LaunchAgent -> ${TARGET_AGENT}"
