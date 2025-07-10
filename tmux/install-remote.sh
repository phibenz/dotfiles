#!/bin/bash

# Remote tmux configuration installation script
# Optimized for SSH connections and remote development

set -e

echo "🌐 Installing remote tmux configuration..."

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "❌ tmux is not installed. Please install tmux first."
    echo "   Ubuntu/Debian: sudo apt install tmux"
    echo "   CentOS/RHEL: sudo yum install tmux"
    echo "   macOS: brew install tmux"
    exit 1
fi

# Backup existing tmux config if it exists
if [ -f ~/.tmux.conf ]; then
    echo "📦 Backing up existing ~/.tmux.conf to ~/.tmux.conf.backup"
    mv ~/.tmux.conf ~/.tmux.conf.backup
fi

# Create symlink to remote tmux config
echo "🔗 Creating symlink to remote tmux configuration..."
ln -sf "$(pwd)/tmux-remote.conf" ~/.tmux.conf

echo "✅ Remote tmux configuration installed successfully!"
echo ""
echo "📋 Key differences from local config:"
echo "   • Prefix: Ctrl-b (default, avoids conflicts with local tmux)"
echo "   • Status bar: Bottom position with hostname and load average"
echo "   • Smaller resize steps (2 cells vs 5)"
echo "   • Higher history limit (10,000 lines)"
echo "   • Optimized for SSH latency"
echo ""
echo "🎯 Key bindings:"
echo "   Prefix: Ctrl-b"
echo "   Navigation: Ctrl-b + hjkl"
echo "   Resize: Ctrl-b + HJKL"
echo "   Reload: Ctrl-b + r"
echo "   Copy mode: Ctrl-b + v"
echo ""
echo "🚀 Start tmux: tmux"