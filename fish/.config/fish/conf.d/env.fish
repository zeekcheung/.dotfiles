# Greeting
set -U fish_greeting

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Misc
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"
set -gx MANROFFOPT -c
source "$HOME/.config/fzf/.fzfrc"

# Rust
set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"

# Path
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.deno/bin"
fish_add_path "$HOME/go/bin"
