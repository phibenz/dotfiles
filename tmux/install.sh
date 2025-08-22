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
mkdir -p ~/.config/tmux/plugins
if [ -d ~/.config/tmux/plugins/tpm ]; then
    cd ~/.config/tmux/plugins/tpm && git pull
else
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

# Install Catppuccin theme
mkdir -p ~/.config/tmux/plugins/catppuccin
if [ -d ~/.config/tmux/plugins/catppuccin/tmux ]; then
    cd ~/.config/tmux/plugins/catppuccin/tmux && git pull
else
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# Install gitmux
if ! command -v gitmux &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install gitmux
    else
        echo "WARNING: gitmux not found and brew not available"
    fi
fi

# Setup gitmux config
mkdir -p ~/.config/tmux
ln -sf "$(realpath .gitmux.yml)" ~/.config/tmux/gitmux.yml

echo "Done. Press Ctrl-a + I in tmux to install plugins."