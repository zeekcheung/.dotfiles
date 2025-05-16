# editor
$env.EDITOR = ""
for $editor in ["nvim" "vim" "vi" "code" "notepad++" "notepad" "nano"] {
  if (((which $editor) | length) > 0) {
    $env.EDITOR = $editor
    break
  }
}

# misc
$env.DOT_DIR = "~/.dotfiles"
$env.NOTE_DIR = "~/OneDrive/Obsidian"

# fzf
$env.FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env.FZF_DEFAULT_OPTS = r#'--ansi --cycle --reverse --border --height 100% --preview='bat --color=always --theme=ansi --decorations=never {}' --preview-window='right,50%,border-left' --color=bg:-1 --color=gutter:-1'#
$env.FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env.FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env.FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# rustup
$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# fnm
fnm env --json | from json | load-env
$env.PATH ++= [ ($env.FNM_MULTISHELL_PATH) ]

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# Load platform specific env
const os_name = $nu.os-info.name
source $"./($os_name)/env.nu"
