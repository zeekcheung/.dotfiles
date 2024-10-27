function note --description "Fuzzy find a note file and open it with vi"
    if test -n "$argv"
        vi "$NOTE_DIR/$argv"
    else
        pushd "$NOTE_DIR"
        vf $argv
        popd
    end
end
