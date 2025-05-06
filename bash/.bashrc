# Shared environment variables, aliases, and functions
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

# Options
shopt -s autocd
shopt -s cdable_vars
shopt -s cmdhist
shopt -s histappend

HISTFILE="$HOME/.bash_history"
HISTSIZE=10000

# Completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

for file in ~/.bash_completion.d/*; do
  source "$file"
done

# Tools
eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fnm env --use-on-cd --shell bash)"
