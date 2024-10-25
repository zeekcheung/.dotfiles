# Greeting
set -U fish_greeting

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx DOT_DIR "$HOME/.dotfiles"
set -gx NOTE_DIR "$HOME/notes"

# Misc
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"
set -gx MANROFFOPT -c
source "$HOME/.config/fzf/.fzfrc"

set -gx GOPATH "$HOME/go"
set -gx CARGO_HOME "$HOME/.cargo"
set -gx RUSTUP_HOME "$HOME/.rustup"
set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"
set -gx PNPM_HOME "$HOME/.pnpm"
set -gx DENO_INSTALL_ROOT "$HOME/.deno/bin"
set -gx PIPX_BIN_DIR "$HOME/.pipx/bin"

# Path
fish_add_path "$PIPX_BIN_DIR"
fish_add_path "$DENO_INSTALL_ROOT"
fish_add_path "$PNPM_HOME"
fish_add_path "$CARGO_HOME/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$HOME/.local/bin"
