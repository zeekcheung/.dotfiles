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
alias gca "git commit --amend --no-edit"
alias gd "git diff"
alias gl "git log"
alias gp "git push --force"
alias gr "git rebase"
alias gt "git status"

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
alias dconf-backup "dconf dump / > $dconf_settings"
alias dconf-restore "dconf load / < $dconf_settings"

# Key bindings
function fish_user_key_bindings
    set -g fish_escape_delay_ms 10
    set -g fish_sequence_key_delay_ms 200
    set -g fish_key_bindings fish_vi_key_bindings

    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    bind -M insert -m default jj cancel repaint-mode
end

function add_newline --description "Add new line before prompt" --on-event fish_postexec
    echo
end


function dus
    set -q $argv; and echo $argv; or echo "."
    du -h $argv --max-depth=1 | sort -h
end

function vf --description "Fuzzy find a file and open it with vi"
    set target "$PWD/$argv"
    if test -f $target
        vi $target
    else if test -d $target
        pushd $target
        set file (fzf)
        if test -n "$file"
            vi "$file"
        end
        popd
    end
end

function dot --description "Fuzzy find a dotfile and open it with vi"
    pushd "$DOT_DIR"
    vf $argv
    popd
end

function note --description "Fuzzy find a note file and open it with vi"
    if test -n "$argv"
        vi "$NOTE_DIR/$argv"
    else
        pushd "$NOTE_DIR"
        vf $argv
        popd
    end
end

function yazi --description "Force yazi to use chafa"
    # NOTE: Make sure to restore the `DISPLAY` environment variable for `xdg-open` via the `[opener]` config in `~/.config/yazi/yazi.toml`
    env -u XDG_SESSION_TYPE -u WAYLAND_DISPLAY -u DISPLAY /usr/bin/yazi $argv
end

function y --description "Yazi shell wrapper"
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Tools
fzf --fish | source
starship init fish | source
zoxide init fish | source
