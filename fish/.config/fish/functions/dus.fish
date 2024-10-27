function dus
    set -q $argv; and echo $argv; or echo "."
    du -h $argv --max-depth=1 | sort -h
end
