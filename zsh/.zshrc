# Zsh configuration
# Minimal native zsh setup with direct plugin sourcing

# Completion
autoload -Uz compinit
compinit

# History search on arrow keys
autoload -Uz history-beginning-search-backward
autoload -Uz history-beginning-search-forward
zle -N history-beginning-search-backward
zle -N history-beginning-search-forward
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Direct plugins
ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Start tmux automatically (if installed) - moved to end to ensure PATH is loaded
# command -v tmux >/dev/null 2>&1 && test -z "$TMUX" && (tmux attach || tmux new-session)
