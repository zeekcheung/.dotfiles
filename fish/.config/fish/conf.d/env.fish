# Use XDG paths for consolidating configuration locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# path
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $N_PREFIX/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $XDG_DATA_HOME/nvim/mason/bin
fish_add_path $XDG_DATA_HOME/share/bob/nvim-bin

# language environment
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# man pager
set -gx MANPAGER "sh -c 'col -bx | bat --theme=ansi -l man -p'"
set -gx MANROFFOPT -c

# n/node.js
set -gx N_PREFIX $HOME/.n

# fzf
set -gx FZF_DEFAULT_OPTS "
--layout=reverse
--inline-info
--ansi
--cycle
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle,ctrl-y:accept
--preview='echo {}\n && fzf-preview {}'
--preview-window=right,60%
--color=bg+:-1
--color=border:#589ed7 
--color=fg:#c8d3f5 
--color=gutter:#1e2030 
--color=header:#ff966c 
--color=hl+:#65bcff 
--color=hl:#65bcff 
--color=info:#545c7e 
--color=marker:#ff007c 
--color=pointer:#ff007c 
--color=prompt:#65bcff 
--color=query:#c8d3f5:regular 
--color=scrollbar:#589ed7 
--color=separator:#ff966c 
--color=spinner:#ff008c 
"
