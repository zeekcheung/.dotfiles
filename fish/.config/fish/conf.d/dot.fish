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
