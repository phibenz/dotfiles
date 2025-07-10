#!/bin/bash

# Tmux configuration installation script
# This script sets up tmux configuration and plugins

set -e

echo "🔧 Installing tmux configuration..."

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "❌ tmux is not installed. Please install tmux first."
    echo "   macOS: brew install tmux"
    echo "   Ubuntu/Debian: sudo apt install tmux"
    exit 1
fi

# Backup existing tmux config if it exists
if [ -f ~/.tmux.conf ]; then
    echo "📦 Backing up existing ~/.tmux.conf to ~/.tmux.conf.backup"
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Create symlink to tmux config
echo "🔗 Creating symlink to tmux configuration..."
ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf

# Install TPM (Tmux Plugin Manager)
echo "📥 Installing TPM (Tmux Plugin Manager)..."
if [ -d ~/.tmux/plugins/tpm ]; then
    echo "   TPM already exists, updating..."
    cd ~/.tmux/plugins/tpm && git pull
else
    echo "   Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "✅ Tmux configuration installed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Start tmux: tmux"
echo "2. Install plugins: Press Ctrl-a + I (capital i)"
echo "3. Reload config: Press Ctrl-a + r"
echo ""
echo "🎯 Key bindings:"
echo "   Prefix: Ctrl-a (instead of Ctrl-b)"
echo "   Navigation: Ctrl-a + hjkl"
echo "   Resize: Ctrl-a + HJKL"
echo "   Toggle keybindings: Ctrl-s"