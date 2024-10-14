# Options
setopt AUTO_CD
setopt AUTO_MENU
setopt PUSHD_SILENT
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# Plugin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath+=(/usr/share/zsh/site-functions)
fpath+=($HOME/.config/zsh/completions)

# Completion
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

# Keybindings
bindkey "\e[Z" reverse-menu-complete
bindkey "^F" autosuggest-accept
bindkey -M viins jj vi-cmd-mode

# Alias
alias ls="eza --color=always --group-directories-first"
alias la="ls -a"
alias ll="ls -l"
alias l="ls -la"
alias se="sudoedit"
alias tree="exa --tree"
alias dus="du -hs * | sort -h"

# Git
alias gg="lazygit"
alias gt="git status"
alias grp="git rebase --continue && git push --force-with-lease"

# Nvim
alias vi="nvim"
alias diff="nvim -d"

# Tmux
alias tm="tmux new-session -A -s main"
alias tk="tmux kill-session"
alias tl="tmux list-sessions"

# Paru
alias p="paru"
alias pas="paru -S"
alias par="paru -Rns"
alias paq="paru -Q"
alias pau="paru -Syyu"

function precmd() {
  function precmd() {
    echo
  }
}

function vf() {
  local file="$(fzf)"
  if [ -n "$file" ]; then
    vi "$file"
  fi
}

function dot() {
  local dot_dir="$HOME/.dotfiles"
  local target_dir=$dot_dir
  if [ -n "$1" ]; then
    target_dir+="/$1"
  fi
  pushd "$target_dir"
  vf
  popd
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
