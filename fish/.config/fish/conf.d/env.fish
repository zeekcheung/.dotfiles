# XDG
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# misc
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "sh -c 'col -bx | bat --theme=ansi -l man -p'"
set -gx MANROFFOPT -c
set -gx N_PREFIX $HOME/.n
source "$HOME/.cargo/env" 2>/dev/null
source "$HOME/.fzfrc" 2>/dev/null

# rustup mirror
set -gx RUSTUP_DIST_SERVER "https://mirrors.ustc.edu.cn/rust-static"
set -gx RUSTUP_UPDATE_ROOT "https://mirrors.ustc.edu.cn/rust-static/rustup"

# path
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $N_PREFIX/bin
fish_add_path $XDG_DATA_HOME/bob/nvim-bin
fish_add_path $XDG_DATA_HOME/nvim/mason/bin
