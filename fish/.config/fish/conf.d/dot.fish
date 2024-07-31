function fzf_filename_first --description "Fuzzy find with filename_first format and preview"
    fzf --delimiter / --with-nth -2,-1 --preview 'echo {}\n && fzf-preview {}'
end

function ff --description "Fuzzy find files and process the result"
    fd . $argv | string trim --right --chars=/ | fzf_filename_first
end

function vf --description "Fuzzy find a file and open with the editor specified in \$EDITOR"
    set -l file (ff $argv)
    if test -n "$file"
        $EDITOR "$file"
    end
end

function dot --description "Fuzzy find a dotfile and open with the editor specified in \$EDITOR"
    if test (count $argv) -eq 0
        vf -H ~/.dotfiles/
    else
        set -l subdir $argv[1]
        vf -H ~/.dotfiles/$subdir/
    end
end
