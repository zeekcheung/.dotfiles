# Define completion for the dot function
complete --no-files --command dot --arguments "(ls -d ~/.dotfiles/*/ | cut -f 5 -d '/')" --description "Package dotfiles to search"
