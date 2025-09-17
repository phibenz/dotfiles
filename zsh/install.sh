#!/bin/bash

# Zsh configuration installation script
# Sets up modern zsh config with useful features

set -e

echo "Installing Zsh configuration..."

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "ERROR: Zsh not found. Install with your package manager:"
    echo "  macOS: brew install zsh"
    echo "  Ubuntu/Debian: apt install zsh"
    echo "  Fedora: dnf install zsh"
    exit 1
fi

# Check zsh version (require 5.0+)
zsh_version=$(zsh --version | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
min_version="5.0"
if ! printf '%s\n' "$min_version" "$zsh_version" | sort -V | head -n1 | grep -q "$min_version"; then
    echo "WARNING: Zsh $zsh_version may be too old. Recommended v5.0+"
fi

# Backup existing zshrc if it exists
if [ -f ~/.zshrc ]; then
    echo "Backing up existing .zshrc..."
    cp ~/.zshrc ~/.zshrc.backup
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed."
fi

# Install additional plugins
echo "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Starship prompt
echo "Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install starship
    else
        curl -sS https://starship.rs/install.sh | sh
    fi
else
    echo "Starship already installed."
fi

# Install Hack Nerd Font
echo "Installing Hack Nerd Font..."

# Determine font directory based on OS
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    FONT_DIR="$HOME/Library/Fonts"
    FONT_CHECK="$FONT_DIR/HackNerdFont-Regular.ttf"
else
    # Linux/Ubuntu
    FONT_DIR="$HOME/.fonts"
    FONT_CHECK="$FONT_DIR/HackNerdFont-Regular.ttf"
fi

if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

# Download and install Hack Nerd Font
if [ ! -f "$FONT_CHECK" ]; then
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
    tar -xf Hack.tar.xz
    mv *.ttf "$FONT_DIR/"
    rm -f Hack.tar.xz LICENSE.md README.md

    # Update font cache on Linux
    if [ "$(uname)" != "Darwin" ] && command -v fc-cache &> /dev/null; then
        fc-cache -fv
    fi

    echo "Hack Nerd Font installed!"
else
    echo "Hack Nerd Font already installed."
fi

# Create symlinks
echo "Creating symlinks..."
ln -sf "$(pwd)/.zshrc" ~/.zshrc

# Create starship config directory and symlink
mkdir -p ~/.config
if [ -f "$(pwd)/starship.toml" ]; then
    ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        sudo dscl . -create /Users/$USER UserShell $(which zsh)
    else
        # Linux
        chsh -s $(which zsh)
    fi
    echo "Shell changed to zsh. Please log out and log back in for changes to take effect."
else
    echo "Zsh is already your default shell."
fi

echo "Configuration installed!"
echo "Reload your terminal or run: source ~/.zshrc"
