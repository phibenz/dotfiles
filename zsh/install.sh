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

# Install Spaceship prompt theme
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    echo "Installing Spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
else
    echo "Spaceship prompt already installed."
fi

# Install Hack Nerd Font
echo "Installing Hack Nerd Font..."
if [ ! -d "$HOME/Library/Fonts" ]; then
    mkdir -p "$HOME/Library/Fonts"
fi

# Download and install Hack Nerd Font
if [ ! -f "$HOME/Library/Fonts/HackNerdFont-Regular.ttf" ]; then
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
    tar -xf Hack.tar.xz
    mv *.ttf "$HOME/Library/Fonts/"
    rm -f Hack.tar.xz LICENSE.md README.md
    echo "Hack Nerd Font installed!"
else
    echo "Hack Nerd Font already installed."
fi

# Create symlinks
echo "Creating symlinks..."
ln -sf "$(pwd)/.zshrc" ~/.zshrc
ln -sf "$(pwd)/.spaceshiprc.zsh" ~/.spaceshiprc.zsh

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
