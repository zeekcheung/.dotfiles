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

# path
zsh_add_path() { export PATH="$PATH:$1"; }
zsh_add_path "/usr/local/bin"
zsh_add_path "$HOME/.local/bin"
zsh_add_path "$HOME/.cargo/bin"
zsh_add_path "$HOME/go/bin"
zsh_add_path "$N_PREFIX/bin"
zsh_add_path "$XDG_DATA_HOME/bob/nvim-bin"
zsh_add_path "$XDG_DATA_HOME/nvim/mason/bin"

# fzf
export FZF_DEFAULT_OPTS="
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

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'fzf-preview {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_CTRL_R_OPTS="
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'
--preview='echo {}'
"

export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'fzf-preview {}'
"
