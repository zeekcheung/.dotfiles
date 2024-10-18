# shellcheck disable=SC2034,SC1094,SC2317

# Shared environment variables, aliases, and functions
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

# Options
setopt AUTO_CD
setopt AUTO_MENU
setopt PUSHD_SILENT
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=25

# Completion
fpath+=(/usr/share/zsh/site-functions)
fpath+=("$HOME/.config/zsh/completions")

autoload -Uz compinit
compinit
zstyle ":completion:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":completion::complete:*" gain-privileges 1

# Prompt
autoload -Uz promptinit
promptinit
prompt walters

# Plugin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Keybindings
bindkey "\e[Z" reverse-menu-complete
bindkey "^F" autosuggest-accept
bindkey -M viins jj vi-cmd-mode

# Add new line before prompt
precmd() {
  precmd() {
    echo
  }
}

# Tools
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
