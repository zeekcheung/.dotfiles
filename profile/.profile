# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DOT_DIR="$HOME/.dotfiles"
export NOTE_DIR="$HOME/notes"

# Misc
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"
source "$HOME/.config/fzf/.fzfrc"

export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
export PNPM_HOME="$HOME/.pnpm"
export DENO_INSTALL_ROOT="$HOME/.deno/bin"
export PIPX_BIN_DIR="$HOME/.pipx/bin"

# Path
add_path() {
  export PATH="$1:$PATH"
}
add_path "$PIPX_BIN_DIR"
add_path "$DENO_INSTALL_ROOT"
add_path "$PNPM_HOME"
add_path "$CARGO_HOME/bin"
add_path "$GOPATH/bin"
add_path "$HOME/.local/bin"

# Alias
alias ls="eza --color=always --sort=Name --group-directories-first"
alias la="ls -a"
alias ll="ls -l"
alias l="ls -la"
alias se="sudoedit"
alias cat="bat -p"
alias tree="eza --color=always --tree"
alias grep="grep --color=always"
alias du="du -h"
alias f="fzf"
alias fetch="fastfetch"
alias zed="zeditor"

# Git
alias gg="lazygit"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log"
alias gf="git fetch"
alias gpl="git pull"
alias gps="git push"
alias gpsf="git push --force"
alias gr="git rebase"
alias grc="git rebase --continue"
alias gri="git rebase --interactive"
alias gst="git status"

# Nvim
alias vi="nvim"
alias diff="nvim -d"

# Tmux
alias tm="tmux new-session -A -s main"
alias tk="tmux kill-session"
alias tl="tmux list-sessions"

# Paru
alias p="paru"
alias pas="paru -S"
alias par="paru -Rns"
alias paq="paru -Q"
alias pau="paru -Syyu"

dus() {
  du -h "${1:-.}" --max-depth=1 | sort -h
}

# dconf
_dconf_settings="$HOME/.config/dconf/settings.ini"
dconf-backup() {
  dconf dump / >"$_dconf_settings"
}
dconf-restore() {
  dconf load / <"$_dconf_settings"
}

# Fuzzy find a file and open it with vi
vf() {
  local target
  target="$(pwd)/$1"
  if [ -f "$target" ]; then
    vi "$target"
  elif [ -d "$target" ]; then
    pushd "$target" || exit
    local file
    file="$(fzf)"
    if [ -n "$file" ]; then
      vi "$file"
    fi
    popd || exit
  fi
}

# Fuzzy find a dotfile and open it with vi
dot() {
  pushd "$DOT_DIR" || exit
  vf "$1"
  popd || exit
}

# Fuzzy find a note file and open it with vi
note() {
  if [ -n "$1" ]; then
    vi "$NOTE_DIR/$1"
  else
    pushd "$NOTE_DIR" || exit
    vf "$1"
    popd || exit
  fi
}

# Force yazi to use chafa
yazi() {
  # NOTE: Make sure to restore the `DISPLAY` environment variable for `xdg-open` via the `[opener]` config in `~/.config/yazi/yazi.toml`
  env -u XDG_SESSION_TYPE -u WAYLAND_DISPLAY -u DISPLAY /usr/bin/yazi "$1"
}

# Yazi shell wrapper
y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || exit
  fi
  rm -f -- "$tmp"
}
