set -l packages (fd . --max-depth=1 --min-depth=1 ~/.dotfiles/ | string trim --right --chars=/ | cut -d '/' -f 5)

for package in $packages
    complete --no-files --command dot --arguments $package --description "$package dotfiles"
end
