# Zsh configuration
# Minimal native zsh setup with direct plugin sourcing

ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

# Completion
autoload -Uz compinit
compinit

# History search on arrow keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# Direct plugins
ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "${ZSH_CONFIG_DIR}/git.plugin.zsh" ]] && source "${ZSH_CONFIG_DIR}/git.plugin.zsh"

# Shell aliases
alias ll='ls -lah'

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
