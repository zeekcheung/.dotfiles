# Zsh options
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=25

# Environment.d
export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Misc
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"
source "$HOME/.config/fzf/.fzfrc"

# Rust
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# Path
zsh_add_path() { export PATH="$1:$PATH" }
zsh_add_path "$HOME/.local/bin"
zsh_add_path "$HOME/.cargo/bin"
zsh_add_path "$HOME/.deno/bin"
zsh_add_path "$HOME/go/bin"

