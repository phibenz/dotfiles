#!/bin/bash

# Tmux configuration installation script
# This script sets up tmux configuration and plugins

set -e

echo "Installing tmux configuration..."

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "ERROR: tmux not found. Install from your package manager."
    exit 1
fi

# Backup existing tmux config if it exists
if [ -f ~/.tmux.conf ]; then
    echo "Backing up existing config..."
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Create symlink to tmux config
echo "Creating symlink..."
ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf

# Install TPM (Tmux Plugin Manager)
if [ -d ~/.tmux/plugins/tpm ]; then
    cd ~/.tmux/plugins/tpm && git pull
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Configuration installed!"
echo "Start tmux and press Ctrl-a + I to install plugins."