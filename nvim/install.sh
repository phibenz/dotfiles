#!/usr/bin/env bash

# Neovim configuration installation script
# Sets up modern Lua-based nvim config with lazy.nvim

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVM_VERSION="v0.40.3"
NODE_VERSION="24"

ensure_nvm_init() {
    local shell_rc
    local nvm_block

    nvm_block=$(cat <<'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
EOF
)

    for shell_rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [[ -f "${shell_rc}" ]] && grep -Fq 'export NVM_DIR="$HOME/.nvm"' "${shell_rc}"; then
            continue
        fi

        if [[ -f "${shell_rc}" ]]; then
            printf '\n%s\n' "${nvm_block}" >> "${shell_rc}"
        else
            printf '%s\n' "${nvm_block}" > "${shell_rc}"
        fi
    done
}

load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

ensure_nvm_node() {
    if ! command -v curl &> /dev/null; then
        echo "ERROR: curl is required to install nvm."
        return 1
    fi

    if ! command -v nvm &> /dev/null; then
        if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
            echo "Installing nvm..."
            curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
        fi

        ensure_nvm_init
        load_nvm
    fi

    if ! command -v nvm &> /dev/null; then
        echo "ERROR: nvm is not available after installation."
        return 1
    fi

    if nvm use "${NODE_VERSION}" >/dev/null 2>&1; then
        echo "Node.js ${NODE_VERSION} already installed via nvm."
        return 0
    fi

    echo "Installing Node.js ${NODE_VERSION} via nvm..."
    nvm install "${NODE_VERSION}"
}

echo "Installing Neovim configuration..."

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo "ERROR: Neovim not found. Install from your package manager or https://github.com/neovim/neovim/releases"
    exit 1
fi

# Check nvim version (require 0.11+)
nvim_version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | cut -c2-)
min_version="0.11"
if ! printf '%s\n' "$min_version" "$nvim_version" | sort -V | head -n1 | grep -q "$min_version"; then
    echo "ERROR: Neovim $nvim_version is too old. Requires v0.11+"
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
ln -sfn "${SCRIPT_DIR}" ~/.config/nvim

if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt-get &> /dev/null; then
    sudo apt-get update
fi

# Install ripgrep (required for some plugins)
echo "Installing ripgrep..."
if command -v rg &> /dev/null; then
    echo "ripgrep already installed."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        brew install ripgrep
    else
        echo "WARNING: Homebrew not found. Please install ripgrep manually with 'brew install ripgrep'"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y ripgrep
    else
        echo "WARNING: Package manager not detected. Please install ripgrep manually"
    fi
else
    echo "WARNING: OS not detected. Please install ripgrep manually"
fi

# Install Mason dependencies
echo "Installing Mason dependencies..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    ensure_nvm_node
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        echo "Installing build dependencies..."
        sudo apt-get install -y curl unzip build-essential
        ensure_nvm_node
    else
        echo "WARNING: apt-get not found. Skipping Mason dependencies installation."
    fi
fi

# Install lazy.nvim plugin manager
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
[ ! -d "$LAZY_PATH" ] && git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"

echo "Configuration installed!"
echo "Start nvim and plugins will auto-install. Run :checkhealth to verify."
