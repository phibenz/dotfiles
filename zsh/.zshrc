# Zsh Configuration with Oh My Zsh
# Modern zsh config with useful features and optimizations

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(
    git
    docker
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load Spaceship prompt configuration
[ -f ~/.spaceshiprc.zsh ] && source ~/.spaceshiprc.zsh

# Directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lah'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'

# Load local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Start tmux automatically (if installed) - moved to end to ensure PATH is loaded
# command -v tmux >/dev/null 2>&1 && test -z "$TMUX" && (tmux attach || tmux new-session)
