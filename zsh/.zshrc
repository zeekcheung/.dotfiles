# shellcheck disable=SC1094,SC2317,SC2296,SC2086

# Shared environment variables, aliases, and functions
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

# Environment variables
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export KEYTIMEOUT=20

# Zsh Options `man zshoptions`

# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
# Completion
setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
# Expansion and Globbing
# setopt GLOBDOTS
# History
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# Input/Output
# setopt CORRECT
setopt INTERACTIVE_COMMENTS


# Zsh Completions `man zshcompsys`
fpath+=(/usr/share/zsh/site-functions)
fpath+=("$HOME/.zsh/completions")

zmodload zsh/complist
autoload -Uz compinit
compinit

zstyle ":completion:*" menu select
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
# zstyle ":completion:*" file-sort change
zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
zstyle ":completion::complete:*" gain-privileges 1

# Prompt
autoload -Uz promptinit
promptinit
prompt walters

# Plugin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Key bindings
bindkey "\e[Z" reverse-menu-complete
bindkey "^F" autosuggest-accept
bindkey -M viins jj vi-cmd-mode

# Text objects for vi-mode
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# Surrounding for vi-mode
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Add new line before prompt
# precmd() {
#   precmd() {
#     echo
#   }
# }

# Tools
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
