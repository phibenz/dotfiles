#!/usr/bin/env bash
# Install Herdr configuration and the Vim/Neovim navigation plugin.

set -euo pipefail

if ! command -v herdr &> /dev/null; then
    echo "ERROR: herdr not found"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "ERROR: jq is required for Vim/Neovim detection. On macOS, run: brew install jq" >&2
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
ln -sfn "${SCRIPT_DIR}/navigate.sh" "${HERDR_CONFIG_DIR}/navigate.sh"
herdr integration install codex

herdr plugin install paulbkim-dev/vim-herdr-navigation --yes

echo "Herdr configuration and navigation plugin installed."
