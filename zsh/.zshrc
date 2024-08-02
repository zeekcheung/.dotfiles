# shellcheck disable=SC1091,SC1094,SC2086

#####################
#### ZSH OPTIONS ####
#####################

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

####################
#### COMPLETION ####
####################

# Enable auto completion
autoload -U compinit
compinit

# Load advanced auto completion module
zmodload zsh/complist

# Auto completion options
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

# Use shift-tab to access previous completion
bindkey '^[[Z' reverse-menu-complete

#################
#### VI MODE ####
#################

# Enable vi mode
autoload -Uz edit-command-line
zle -N edit-command-line

# Exit insert mode with jj
bindkey -M viins 'jj' vi-cmd-mode

# Add text objects in vi mode
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

# Add surround in vi mode
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

#################
#### PLUGINS ####
#################

PLUGINS_DIR=$XDG_DATA_HOME/zsh

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -d /usr/share/zsh/site-functions ]]; then
  fpath+=/usr/share/zsh/site-functions
elif [[ -d $PLUGINS_DIR/zsh-completions/src ]]; then
  fpath+=$PLUGINS_DIR/zsh-completions/src
fi

# Accept suggestion with <C-f>
bindkey '^F' autosuggest-accept
# Accpet partial suggestion with <A-f>
bindkey '^[f' vi-forward-word

##################
#### ALIASES #####
##################

# misc
alias ~="cd ~"
alias ..="cd .."
alias cd="z"
alias mkdir="mkdir -p"
alias ls="eza --color=auto"
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
alias f="fzf"
alias grep="grep --color=auto"
alias open="xdg-open"
alias cl="clear"

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

###################
#### FUNCTIONS ####
###################

# Add a newline before each prompt except the first line
function precmd() {
	precmd() {
		echo
	}
}

# Set terminal title
function preexec() {
	if [[ -n "$TMUX" ]]; then
		return
	fi
	print -Pn "\e]0;$1\a"
}

# Enable proxy
function proxy-on() {
  export http_proxy="http://127.0.0.1:20171"
  export https_proxy="http://127.0.0.1:20171"
  export all_proxy="socks5://127.0.0.1:20170"
  export no_proxy="127.0.0.1"
}

# Disable proxy
function proxy-off() {
  unset http_proxy
  unset https_proxy
  unset all_proxy
}

# kill tmux session
function tk() {
  if [[ $# -eq 0 ]]; then
    tmux kill-server
  else
    tmux kill-session -t $1
  fi
}

# fuzzy find a file and open in vim
function vf() {
  file=$(fzf)
  [ -n "$file" ] && vi "$file"
}

# fuzzy find a dotfile and open in vim
function dot() {
  file=$(find ~/.dotfiles | fzf)
  [ -n "$file" ] && vi "$file"
}

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
