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

# Install Catppuccin theme
mkdir -p ~/.config/tmux/plugins/catppuccin
if [ -d ~/.config/tmux/plugins/catppuccin/tmux ]; then
    cd ~/.config/tmux/plugins/catppuccin/tmux && git pull
else
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

echo "Done. Press Ctrl-a + I in tmux to install plugins."