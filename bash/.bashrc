#!/usr/bin/env bash

# xdg
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# misc
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="nvim"
export VISUAL="nvim"
export N_PREFIX=$HOME/.n
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat --theme=ansi -l man -p'"
source "$HOME/.cargo/env" 2>/dev/null

# path
bash_add_path() { export PATH="$1:$PATH"; }
bash_add_path "/usr/local/bin"
bash_add_path "$HOME/.local/bin"
bash_add_path "$HOME/.cargo/bin"
bash_add_path "$HOME/go/bin"
bash_add_path "$N_PREFIX/bin"
bash_add_path "$XDG_DATA_HOME/bob/nvim-bin"
bash_add_path "$XDG_DATA_HOME/nvim/mason/bin"

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--inline-info
--ansi
--cycle
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle,ctrl-y:accept
--preview='echo {}\n && fzf-preview {}'
--preview-window=right,60%
--color=bg+:-1
"

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'fzf-preview {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_CTRL_R_OPTS="
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'
--preview='echo {}'
"

export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'fzf-preview {}'
"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Misc
alias ~='cd ~'
alias ..='cd ..'
alias mkdir='mkdir -p'
alias ls='ls --color=auto'
alias l='ls -al'
alias ll='ls -l'
alias la='ls -a'
alias tree="tree -C"
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'
alias open="xdg-open"
alias cl="clear"
alias se="sudoedit"
alias diff="vi -d"

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
alias vi='nvim'

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

# Enable proxy
function proxy-on() {
	export http_proxy="http://127.0.0.1:20171"
	export https_proxy="http://127.0.0.1:20171"
	export all_proxy="socks5://127.0.0.1:20170"
	export no_proxy="127.0.0.1"

	git config --global http.proxy "http://127.0.0.1:20171"
	git config --global https.proxy "http://127.0.0.1:20171"
}

# Disable proxy
function proxy-off() {
	unset http_proxy
	unset https_proxy
	unset all_proxy

	git config --global --unset http.proxy
	git config --global --unset https.proxy
}

# Fuzzy find with filename_first format and preview
function fzf_filename_first() {
	fzf --delimiter / --with-nth -2,-1 --preview 'echo {} && fzf-preview {}'
}

# Fuzzy find with fd and fzf
function f() {
	fd . "$@" | sed 's/\/$//' | fzf_filename_first
}

# Fuzzy find with fd and fzf then open with $EDITOR
function vf() {
	local file
	file=$(f "$@")
	[[ -n "$file" ]] && $EDITOR "$file"
}

# Fuzzy find a dotfile and open with $EDITOR
DOT_DIR="$HOME/.dotfiles"
function dot() {
	if [[ $# -eq 0 ]]; then
		vf -H "$DOT_DIR"
	else
		local target="$DOT_DIR/$1"
		if [[ -d "$target" ]]; then
			vf -H "$target"
		else
			$EDITOR "$target"
		fi
	fi
}

# Kill tmux session
function tk() {
	if [[ $# -eq 0 ]]; then
		tmux kill-server
	else
		tmux kill-session -t "$1"
	fi
}

# yazi
function y() {
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd" || exit
	fi
	rm -f -- "$tmp"
}

# default prompt
# PS2='[\u@\h \W]\$ '

# custom prompt like starship without git branch
PS1='\[\e[1m\e[33m\]\u \[\e[1m\e[36m\]\w\n\[\e[1m\e[32m\]❯ \[\e[0m\]'

# add a newline before each prompt except the first line
PROMPT_COMMAND="export PROMPT_COMMAND=echo"
alias clear="unset PROMPT_COMMAND; clear; PROMPT_COMMAND='export PROMPT_COMMAND=echo'"

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] &&
	. /usr/share/bash-completion/bash_completion

# Tab completion
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

eval "$(fzf --bash)"
# eval "$(starship init bash)"
eval "$(zoxide init bash)"
