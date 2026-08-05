# Zsh configuration
# Minimal native zsh setup with direct plugin sourcing

ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

# Completion
autoload -Uz compinit
compinit

# Line editor widgets
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

insert-literal-newline() {
  LBUFFER+=$'\n'
}
zle -N insert-literal-newline

# Direct plugins
ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "${ZSH_CONFIG_DIR}/ai.plugin.zsh" ]] && source "${ZSH_CONFIG_DIR}/ai.plugin.zsh"
[[ -f "${ZSH_CONFIG_DIR}/git.plugin.zsh" ]] && source "${ZSH_CONFIG_DIR}/git.plugin.zsh"

# Shell aliases
alias ll='ls -lah'
alias wktree="${ZSH_CONFIG_DIR:h}/scripts/worktree-tmux.sh"

suni() {
  if [[ $# -ne 1 ]]; then
    echo "usage: suni <file>" >&2
    return 1
  fi

  sort -u "$1" -o "$1"
}

# Timestamp helpers
hms() {
  TZ=UTC0 date +"%H%M%S"
}

ymd() {
  TZ=UTC0 date +"%y%m%d"
}

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export LANG="${LANG:-C.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-$LANG}"

# Load local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Normalize the interactive keymap after local scripts load.
bindkey -e
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^K' up-line-or-beginning-search
bindkey '^J' down-line-or-beginning-search
bindkey '^L' autosuggest-accept
# iTerm2 maps Ctrl-Enter to Escape + Line Feed (hex 0x1b 0x0a).
bindkey '^[^J' insert-literal-newline
[[ -n "${terminfo[kcuu1]-}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]-}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word

# Initialize Starship prompt (after PATH is set)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Start tmux automatically (if installed) - moved to end to ensure PATH is loaded
# command -v tmux >/dev/null 2>&1 && test -z "$TMUX" && (tmux attach || tmux new-session)
