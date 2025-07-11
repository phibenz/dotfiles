#!/bin/bash

set -e

# Check tmux installation
if ! command -v tmux &> /dev/null; then
    echo "ERROR: tmux not found"
    exit 1
fi

# Backup existing config
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Create symlink
ln -sf "$(pwd)/tmux-remote.conf" ~/.tmux.conf

echo "Remote config installed. Prefix: Ctrl-b"