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
