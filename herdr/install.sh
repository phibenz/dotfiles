#!/usr/bin/env bash

set -euo pipefail

if ! command -v herdr &> /dev/null; then
    echo "ERROR: herdr not found"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERDR_CONFIG_DIR="${HOME}/.config/herdr"
CODEX_CONFIG_DIR="${CODEX_HOME:-${HOME}/.codex}"

if [[ ! -d "${CODEX_CONFIG_DIR}" ]]; then
    echo "ERROR: Codex configuration directory not found: ${CODEX_CONFIG_DIR}" >&2
    echo "Run codex/install.sh before herdr/install.sh." >&2
    exit 1
fi

mkdir -p "${HERDR_CONFIG_DIR}"
ln -sfn "${SCRIPT_DIR}/config.toml" "${HERDR_CONFIG_DIR}/config.toml"
herdr integration install codex

echo "Herdr configuration and Codex integration installed."
