function dot --description "Fuzzy find a dotfile and open it with vi"
    pushd "$DOT_DIR"
    vf $argv
    popd
end
