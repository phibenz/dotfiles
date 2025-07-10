#!/bin/bash

# Neovim configuration installation script
# Sets up modern Lua-based nvim config with lazy.nvim

set -e

echo "🚀 Installing Neovim configuration..."

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo "❌ Neovim is not installed. Please install Neovim first."
    echo "   macOS: brew install neovim"
    echo "   Ubuntu/Debian: sudo apt install neovim"
    echo "   Or download from: https://github.com/neovim/neovim/releases"
    exit 1
fi

# Check nvim version (require 0.8+)
nvim_version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | cut -c2-)
min_version="0.8"
if ! printf '%s\n' "$min_version" "$nvim_version" | sort -V | head -n1 | grep -q "$min_version"; then
    echo "❌ Neovim version $nvim_version is too old. Please upgrade to v0.8 or newer."
    exit 1
fi

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Backup existing nvim config if it exists
if [ -d ~/.config/nvim ]; then
    echo "📦 Backing up existing ~/.config/nvim to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Create symlink to nvim config
echo "🔗 Creating symlink to nvim configuration..."
ln -sf "$(pwd)" ~/.config/nvim

# Install lazy.nvim plugin manager
echo "📥 Installing lazy.nvim plugin manager..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    echo "   Cloning lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
else
    echo "   lazy.nvim already exists"
fi

echo "✅ Neovim configuration installed successfully!"
echo ""
echo "📋 Configuration features:"
echo "   • Modern Lua-based configuration"
echo "   • Lazy.nvim plugin manager"
echo "   • Catppuccin colorscheme"
echo "   • File explorer (Neo-tree)"
echo "   • Fuzzy finder (Telescope)"
echo "   • Syntax highlighting (Treesitter)"
echo "   • GitHub Copilot integration"
echo "   • LSP support with Mason"
echo ""
echo "🎯 Key bindings:"
echo "   Leader key: Space"
echo "   File explorer: Ctrl+n"
echo "   Find files: <leader>ff"
echo "   Live grep: <leader>fg"
echo "   Buffers: <leader>fb"
echo "   Help: <leader>fh"
echo ""
echo "🚀 Next steps:"
echo "1. Start nvim: nvim"
echo "2. Plugins will auto-install on first run"
echo "3. Run :checkhealth to verify setup"
echo "4. Install LSP servers: :Mason"