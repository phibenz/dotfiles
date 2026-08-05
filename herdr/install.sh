#!/usr/bin/env bash

set -euo pipefail

if ! command -v herdr &> /dev/null; then
    echo "ERROR: herdr not found"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERDR_CONFIG_DIR="${HOME}/.config/herdr"

mkdir -p "${HERDR_CONFIG_DIR}"
ln -sfn "${SCRIPT_DIR}/config.toml" "${HERDR_CONFIG_DIR}/config.toml"

echo "Herdr configuration installed."
