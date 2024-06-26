alias ls "eza --color=auto"
# alias ls "ls --color=auto"
alias l "ls -al"
alias la "ls -a"
alias ll "ls -l"
alias tree "eza --tree"
# alias tree "tree -C"
alias df "df -h"
alias du "du -h"
alias f fzf
alias grep "grep --color=auto"
alias cl clear

alias ga "git add"
alias gb "git branch"
alias gc "git commit"
alias gd "git diff"
alias gl "git log"
alias gp "git pull && git push"
alias gt "git status"
alias gg lazygit

alias vi nvim
# ~/.config/nvchad
alias nvchad "env NVIM_APPNAME=nvchad nvim"
# ~/.config/lazyvim
alias lazyvim "env NVIM_APPNAME=lazyvim nvim"

alias t tmux
alias ta "tmux attach -t"
alias td "tmux detach"
alias tk "tmux kill-session -t"
alias tl "tmux ls"
alias tn "tmux new -s"
alias tm "tmux new -A -s main"

function where
    whereis $argv | tr " " "\n" | tail -n +2
end

function vf
    set file (fzf)
    if [ -n "$file" ]; and [ -f "$file" ]
        vi "$file"
    end
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
