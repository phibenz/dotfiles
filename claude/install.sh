#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_INSTRUCTIONS="${REPO_DIR}/agents/AGENTS.md"
TARGET_INSTRUCTIONS="${HOME}/.claude/CLAUDE.md"

echo "Installing Claude Code configuration..."

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code not found. Install from: https://claude.ai/code"
    exit 1
fi

# Check for text-to-speech on Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! command -v espeak &> /dev/null && ! command -v spd-say &> /dev/null; then
        echo "NOTE: For TTS support, install espeak: sudo apt install espeak"
    fi
fi

# Setup directories and backup existing settings
mkdir -p ~/.claude
[ -f ~/.claude/settings.json ] && mv ~/.claude/settings.json ~/.claude/settings.json.backup

# Create symlinks
if [[ -e "${TARGET_INSTRUCTIONS}" && ! -L "${TARGET_INSTRUCTIONS}" ]]; then
    echo "Skipping Claude instructions: ${TARGET_INSTRUCTIONS} exists and is not a symlink"
else
    ln -sfn "${SOURCE_INSTRUCTIONS}" "${TARGET_INSTRUCTIONS}"
fi
ln -sfn "${SCRIPT_DIR}/settings.json" ~/.claude/settings.json
[ -d "${SCRIPT_DIR}/commands" ] && ln -sfn "${SCRIPT_DIR}/commands" ~/.claude/commands

echo "Configuration installed!"
