#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Setup directory and backup existing files
mkdir -p ~/.claude
[ -f ~/.claude/CLAUDE.md ] && mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
[ -f ~/.claude/settings.json ] && mv ~/.claude/settings.json ~/.claude/settings.json.backup

# Create symlinks
ln -sfn "${SCRIPT_DIR}/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sfn "${SCRIPT_DIR}/settings.json" ~/.claude/settings.json
[ -d "${SCRIPT_DIR}/commands" ] && ln -sfn "${SCRIPT_DIR}/commands" ~/.claude/commands

echo "Configuration installed!"
