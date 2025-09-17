#!/bin/bash

# Neovim configuration installation script
# Sets up modern Lua-based nvim config with lazy.nvim

set -e

echo "Installing Neovim configuration..."

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo "ERROR: Neovim not found. Install from your package manager or https://github.com/neovim/neovim/releases"
    exit 1
fi

# Check nvim version (require 0.8+)
nvim_version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | cut -c2-)
min_version="0.8"
if ! printf '%s\n' "$min_version" "$nvim_version" | sort -V | head -n1 | grep -q "$min_version"; then
    echo "ERROR: Neovim $nvim_version is too old. Requires v0.8+"
    exit 1
fi

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Backup existing nvim config if it exists
if [ -d ~/.config/nvim ]; then
    echo "Backing up existing config..."
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Create symlink to nvim config
echo "Creating symlink..."
ln -sf "$(pwd)" ~/.config/nvim

# Install ripgrep (required for some plugins)
echo "Installing ripgrep..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        brew install ripgrep
    else
        echo "WARNING: Homebrew not found. Please install ripgrep manually with 'brew install ripgrep'"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y ripgrep
    else
        echo "WARNING: Package manager not detected. Please install ripgrep manually"
    fi
else
    echo "WARNING: OS not detected. Please install ripgrep manually"
fi

# Install lazy.nvim plugin manager
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
[ ! -d "$LAZY_PATH" ] && git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"

echo "Configuration installed!"
echo "Start nvim and plugins will auto-install. Run :checkhealth to verify."
