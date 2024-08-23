# misc
alias ls "eza --color=auto --group-directories-first"
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
alias se sudoedit
alias diff "vi -d"

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

# paru
alias p paru
alias ps "paru -S"
alias pr "paru -Rns"
alias pc "paru -c"
alias pq "paru -Q"

function tk --description "Kill tmux session"
    count $argv >/dev/null && tmux kill-session -t $argv || tmux kill-server
end

function where --description Where
    whereis $argv | tr " " "\n" | tail -n +2
end

function y --description Yazi
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    set hyprland_animate (
        rg --multiline --quiet "animations\s*\{\s*enabled\s*=\s*true" "$HOME/.config/hypr/hyprland.conf"
        ;and echo true; or echo false
    )
    if type -q ueberzugpp; and $hyprland_animate
        yazi $argv --cwd-file="$tmp"
    else
        env -u XDG_SESSION_TYPE -u WAYLAND_DISPLAY -u DISPLAY yazi $argv --cwd-file="$tmp"
    end
    # yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
