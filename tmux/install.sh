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
ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf

# Install TPM
if [ -d ~/.tmux/plugins/tpm ]; then
    cd ~/.tmux/plugins/tpm && git pull
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Done. Press Ctrl-a + I in tmux to install plugins."