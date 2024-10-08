if status is-interactive
    # Remove greeting message
    set -g fish_greeting ""

    # Add newline after each command
    function add_newline --on-event fish_postexec
        test $argv != cl && test $argv != clear && echo
    end

    # Vi mode
    set -g fish_key_bindings fish_vi_key_bindings
    set -g fish_sequence_key_delay_ms 200

    bind -M insert -m default jj cancel repaint-mode

    function fish_user_key_bindings
        for mode in insert default visual
            bind -M $mode \cf forward-char
            bind -M $mode \ef forward-word
        end

        fzf --fish | source
    end

    # Misc
    alias ls "eza --color=auto --group-directories-first"
    # alias ls "ls --color=auto"
    alias l "ls -al"
    alias la "ls -a"
    alias ll "ls -l"
    alias cat bat
    alias less bat
    alias tree "eza --tree"
    # alias tree "tree -C"
    alias df "df -h"
    alias du "du -h"
    alias grep "grep --color=auto"
    alias open xdg-open
    alias cl clear
    alias se sudoedit
    alias diff "vi -d"
    alias fetch fastfetch

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

    function where --description "Where is command"
        whereis $argv | tr " " "\n" | tail -n +2
    end

    function dus --description "Disk usage with sorting"
        du -h -d 1 $1 | sort -h
    end

    function proxy-on --description "Enable proxy"
        set -gx http_proxy "http://127.0.0.1:20171"
        set -gx https_proxy "http://127.0.0.1:20171"
        set -gx all_proxy "socks5://127.0.0.1:20170"
        set -gx no_proxy "127.0.0.1"

        git config --global http.proxy "http://127.0.0.1:20171"
        git config --global https.proxy "http://127.0.0.1:20171"
    end

    function proxy-off --description "Disable proxy"
        set -e http_proxy
        set -e https_proxy
        set -e all_proxy

        git config --global --unset http.proxy
        git config --global --unset https.proxy
    end

    function fzf_filename_first --description "Fuzzy find with filename_first format and preview"
        fzf --delimiter / --with-nth -2,-1 --preview 'echo {}\n && fzf-preview {}'
    end

    function f --description "Fuzzy find with fd and fzf"
        fd . $argv | string trim --right --chars=/ | fzf_filename_first
    end

    function ff --description "Faster fuzzy find with fd and fzf"
        fd . $argv | fzf
    end

    function vf --description "Fuzzy find with fd and fzf then open with $EDITOR"
        set -l file (f $argv)
        test -n "$file" && $EDITOR "$file"
    end

    function dot --description "Fuzzy find a dotfile and open with $EDITOR"
        if test (count $argv) -eq 0
            vf -H ~/.dotfiles/
        else
            set -l target ~/.dotfiles/$argv[1]
            test -d "$target" && vf -H "$target" || $EDITOR "$target"
        end
    end

    function tk --description "Kill tmux session"
        count $argv >/dev/null && tmux kill-session -t $argv || tmux kill-server
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

    fzf --fish | source
    starship init fish | source
    zoxide init fish | source
end

# if status --is-login
#     # Auto start hyprland
#     if test (tty) = /dev/tty1
#         dbus-run-session Hyprland
#     end
# end
