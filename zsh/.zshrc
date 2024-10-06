# ZSH OPTIONS
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt globdots
unsetopt AUTO_REMOVE_SLASH
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY
unsetopt nomatch

HISTFILE=$XDG_DATA_HOME/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=20

# COMPLETION
autoload -Uz compinit
compinit
zmodload zsh/complist

zstyle ":completion:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

bindkey '^[[Z' reverse-menu-complete

# PROMPT
autoload -Uz promptinit
promptinit
prompt walters

# VI MODE
autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -M viins 'jj' vi-cmd-mode
bindkey '^F' autosuggest-accept
bindkey '^[f' vi-forward-word
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[3~' delete-char

# Text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for prefix in a i; do
    for postfix in "'" '"' '`' '|' ',' '.' '/' ':' ';' '=' '+' '@'; do
      bindkey -M $km $prefix$postfix select-quoted
    done
  done
  for prefix in a i; do
    for postfix in '(' ')' '[' ']' '{' '}' '<' '>' 'b' 'B'; do
      bindkey -M $km $prefix$postfix select-bracketed
    done
  done
done

# Surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# PLUGINS
PLUGINS_DIR="/usr/share/zsh/plugins"
source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=(/usr/share/zsh/site-functions $PLUGINS_DIR/zsh-completions/src)

# Avoid comments are invisible when using syntax highlighting
ZSH_HIGHLIGHT_STYLES[comment]='none'

# ALIASES
alias ~="cd ~"
alias ..="cd .."
# alias cd="z"
alias ls="eza --color=auto --group-directories-first"
# alias ls="ls --color=auto"
alias l="ls -al"
alias la="ls -a"
alias ll="ls -l"
alias cat="bat"
alias less="bat"
alias tree="eza --tree"
# alias tree="tree -C"
alias df="df -h"
alias du="du -h"
alias grep="grep --color=auto"
alias open="xdg-open"
alias c="clear"
alias se="sudoedit"
alias diff="vi -d"
alias fetch="fastfetch"

# git
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git pull && git push"
alias gt="git status"
alias gg="lazygit"

# nvim
alias vi="nvim"
# ~/.config/nvchad
alias nvchad="env NVIM_APPNAME=nvchad nvim"
# ~/.config/lazyvim
alias lazyvim="env NVIM_APPNAME=lazyvim nvim"

# tmux
alias t="tmux"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tl="tmux ls"
alias tn="tmux new -s"
alias tm="tmux new -A -s main"

# paru
alias p="paru"
alias ps="paru -S"
alias pr="paru -Rns"
alias pc="paru -c"
alias pq="paru -Q"

# FUNCTIONS

# Add a newline before each prompt except the first line
preexec() {
  local cmd="$1"
  # Set terminal title
  [[ -z "$TMUX" ]] && print -Pn "\e]0;$cmd\a"
  [[ "$cmd" == "clear" || "$cmd" == "cl" ]] && last_is_clear=true || last_is_clear=false
}
precmd() {
  [[ "$last_is_clear" == false ]] && echo
}

dus() {
  du -h -d 1 $1 | sort -h
}

# Enable proxy
proxy-on() {
  export http_proxy="http://127.0.0.1:20171"
  export https_proxy="http://127.0.0.1:20171"
  export all_proxy="socks5://127.0.0.1:20170"
  export no_proxy="127.0.0.1"

  git config --global http.proxy "http://127.0.0.1:20171"
  git config --global https.proxy "http://127.0.0.1:20171"
}

# Disable proxy
proxy-off() {
  unset http_proxy
  unset https_proxy
  unset all_proxy

  git config --global --unset http.proxy
  git config --global --unset https.proxy
}

# Fuzzy find with filename_first format and preview
fzf_filename_first() {
  fzf --delimiter / --with-nth -2,-1 --preview 'echo {} && fzf-preview {}'
}

# Fuzzy find with fd and fzf
f() {
  fd . "$@" | sed 's/\/$//' | fzf_filename_first
}

# Faster fuzzy find with fd and fzf
ff() {
  fd . "$@" | fzf
}

# Fuzzy find with fd and fzf then open with $EDITOR
vf() {
  local file=$(f "$@")
  [[ -n "$file" ]] && $EDITOR "$file"
}

# Fuzzy find a dotfile and open with $EDITOR
DOT_DIR="$HOME/.dotfiles"
dot() {
  if [[ $# -eq 0 ]]; then
    vf -H "$DOT_DIR"
  else
    local target="$DOT_DIR/$1"
    [[ -d "$target" ]] && vf -H "$target" || $EDITOR "$target"
  fi
}
_dot() {
  compadd $(fd . --max-depth=1 --min-depth=1 "$DOT_DIR" | sed 's:/*$::' | cut -d '/' -f 5)
}
compdef _dot dot

# Kill tmux session
tk() {
  [[ $# -eq 0 ]] && tmux kill-server || tmux kill-session -t $1
}

# yazi
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  # Image preview with ueberzugpp or chafa
  # local ueberzugpp_available=$(command -v ueberzugpp &>/dev/null && echo true || echo false)
  # local hyprland_animate=$(
  #   rg --multiline --quiet "animations\s*\{\s*enabled\s*=\s*true" "$HOME/.config/hypr/hyprland.conf" && echo true || echo false
  # )
  # if $ueberzugpp_available && $hyprland_animate; then
  #   yazi "$@" --cwd-file="$tmp"
  # else
  #   env -u XDG_SESSION_TYPE -u WAYLAND_DISPLAY -u DISPLAY yazi "$@" --cwd-file="$tmp"
  # fi
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
