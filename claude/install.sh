#!/bin/bash
set -e

echo "Installing Claude Code configuration..."

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code not found. Install from: https://claude.ai/code"
    exit 1
fi

# Setup directory and backup existing files
mkdir -p ~/.claude
[ -f ~/.claude/CLAUDE.md ] && mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
[ -f ~/.claude/settings.json ] && mv ~/.claude/settings.json ~/.claude/settings.json.backup

# Create symlinks
ln -sf "$(pwd)/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$(pwd)/settings.json" ~/.claude/settings.json
[ -d "$(pwd)/commands" ] && ln -sf "$(pwd)/commands" ~/.claude/commands

echo "Configuration installed!"
