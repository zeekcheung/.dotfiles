# xdg
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# misc
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="sh -c 'col -bx | bat --theme=ansi -l man -p'"
export MANROFFOPT="-c"
export N_PREFIX="$HOME/.n"
source "$HOME/.cargo/env" 2>/dev/null
source "$HOME/.fzfrc" 2>/dev/null

# rustup mirror
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

# path
zsh_add_path() { export PATH="$PATH:$1"; }
zsh_add_path "/usr/local/bin"
zsh_add_path "$HOME/.local/bin"
zsh_add_path "$HOME/.cargo/bin"
zsh_add_path "$HOME/go/bin"
zsh_add_path "$N_PREFIX/bin"
zsh_add_path "$XDG_DATA_HOME/bob/nvim-bin"
zsh_add_path "$XDG_DATA_HOME/nvim/mason/bin"
