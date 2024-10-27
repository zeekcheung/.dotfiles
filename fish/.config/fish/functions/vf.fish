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
