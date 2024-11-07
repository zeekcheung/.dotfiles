# Only setup aliases and shell integrations in interactive mode
if not status is-interactive
    return 0
end

if status is-login
    # Start Hyprland on tty1
    if test "$(tty)" = /dev/tty1
        exec Hyprland
    end
end

# Alias
alias ls "eza --color=always --sort=Name --group-directories-first"
alias la "ls -a"
alias ll "ls -l"
alias l "ls -la"
alias se sudoedit
alias cat "bat -p"
alias tree "eza --color=always --tree"
alias grep "grep --color=always"
alias du "du -h"
alias f fzf
alias fetch fastfetch
alias zed zeditor

# Git
alias gg lazygit
alias ga "git add"
alias gb "git branch"
alias gc "git commit"
alias gcm "git commit -m"
alias gca "git commit --amend --no-edit"
alias gco "git checkout"
alias gd "git diff"
alias gl "git log"
alias gf "git fetch"
alias gpl "git pull"
alias gps "git push"
alias gpsf "git push --force"
alias gr "git rebase"
alias grc "git rebase --continue"
alias gri "git rebase --interactive"
alias gst "git status"

# Nvim
alias vi nvim
alias diff "nvim -d"

# Tmux
alias tm "tmux new-session -A -s main"
alias tk "tmux kill-session"
alias tl "tmux list-sessions"

# Paru
alias p paru
alias pas "paru -S"
alias par "paru -Rns"
alias paq "paru -Q"
alias pau "paru -Syyu"

# dconf
set dconf_settings "$HOME/.config/dconf/settings.ini"
alias dconf-backup "dconf dump / >$dconf_settings"
alias dconf-restore "dconf load / < $dconf_settings"

function add_newline --description "Add new line before prompt" --on-event fish_postexec
    echo
end

# Tools
fzf --fish | source
starship init fish | source
zoxide init fish | source
