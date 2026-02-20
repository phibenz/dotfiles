# Zsh Configuration with Oh My Zsh
# Modern zsh config with useful features and optimizations

# Catppuccin theme for zsh-syntax-highlighting (must be sourced before plugin)
[ -f ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
    git
    docker
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Directory aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lah'
alias gs='git status'

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'

# Load local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Initialize Starship prompt (after PATH is set)
eval "$(starship init zsh)"

# Start tmux automatically (if installed) - moved to end to ensure PATH is loaded
# command -v tmux >/dev/null 2>&1 && test -z "$TMUX" && (tmux attach || tmux new-session)
