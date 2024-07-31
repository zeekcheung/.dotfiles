# misc
alias ls "eza --color=auto"
# alias ls "ls --color=auto"
alias l "ls -al"
alias la "ls -a"
alias ll "ls -l"
alias tree "eza --tree"
# alias tree "tree -C"
alias cat bat
alias less bat
alias df "df -h"
alias du "du -h"
alias grep "grep --color=auto"
alias cl clear

# git
alias ga "git add"
alias gb "git branch"
alias gc "git commit"
alias gd "git diff"
alias gl "git log"
alias gp "git pull && git push"
alias gt "git status"
alias gg lazygit

# nvim
alias vi nvim
# ~/.config/nvchad
alias nvchad "env NVIM_APPNAME=nvchad nvim"
# ~/.config/lazyvim
alias lazyvim "env NVIM_APPNAME=lazyvim nvim"

# tmux
alias t tmux
alias ta "tmux attach -t"
alias td "tmux detach"
alias tl "tmux ls"
alias tn "tmux new -s"
alias tm "tmux new -A -s main"

function tk --description "Kill tmux session"
    if count $argv >/dev/null
        tmux kill-session -t $argv
    else
        tmux kill-server
    end
end

function where --description Where
    whereis $argv | tr " " "\n" | tail -n +2
end


# yazi
function y --description Yazi
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
