# Find a detailed list of available settings using:
# config nu --doc | nu-highlight | less -R

# Nushell
$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = $env.EDITOR
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = false
$env.config.use_kitty_protocol = true
$env.config.shell_integration.osc2 = true
$env.config.shell_integration.osc7 = true
$env.config.shell_integration.osc8 = true
$env.config.shell_integration.osc133 = true
$env.config.shell_integration.osc633 = true
$env.config.bracketed_paste = true
$env.config.error_style = "fancy"
$env.config.table.mode = "default"
$env.config.filesize.unit = "metric"
$env.config.cursor_shape.vi_normal = "block"
# $env.config.cursor_shape.vi_insert = "block"
$env.config.color_config.shape_garbage = { fg: "red" bg: "default" attr: b }

# Keybindings
$env.config.edit_mode = "vi"
$env.config.keybindings ++= [
  {
    name: accept_suggestion
    modifier: control
    keycode: char_f
    mode: [emacs vi_insert vi_normal]
    event: {send: HistoryHintComplete}
  },
  {
    name: fzf_history
    modifier: control
    keycode: char_r
    mode: [emacs vi_insert vi_normal]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "commandline edit --insert (
          history | get command | reverse | uniq | str join (char -i 0)
            | fzf --preview 'echo {}' --preview-window wrap --read0
            | decode utf-8 | str trim
        )"
      }
    ]
  },
  {
    name: fzf_files
    modifier: control
    keycode: char_t
    mode: [emacs vi_insert vi_normal]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "commandline edit --insert (nu -l -i -c $'($env.FZF_CTRL_T_COMMAND) | fzf ($env.FZF_CTRL_T_OPTS)')"
      }
    ]
  },
  {
    name: fzf_dirs
    modifier: alt
    keycode: char_c
    mode: [emacs vi_insert vi_normal]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "cd (nu -c $'($env.FZF_ALT_C_COMMAND) | fzf ($env.FZF_ALT_C_OPTS)')"
      }
    ]
  }
]

# Starship prompt
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""

# Aliases
alias la = ls -a
alias ll = ls -l
alias l = ls -a -l
alias se = sudoedit
alias cat = bat -p
alias grep = grep --color=always
alias f = fzf
alias fetch = fastfetch
alias zed = zededitor

alias gg = lazygit
alias ga = git add
alias gb = git branch
alias gc = git commit
alias gcm = git commit - m
alias gca = git commit --amend --no-edit
alias gco = git checkout
alias gd = git diff
alias gl = git log
alias gf = git fetch
alias gpl = git pull
alias gps = git push
alias gpsf = git push --force
alias gr = git rebase
alias grc = git rebase --continue
alias gri = git rebase --interactive
alias gst = git status

alias vi = nvim
alias diff = nvim -d

# Fuzzy find a file and open it with the editor
def vf [target?: string] {
  let current_dir = $env.PWD

  # If no target is provided, use the current directory
  # Otherwise, join the current directory with the target
  let full_path = if ($target | is-empty) {
    $current_dir
  } else {
    $current_dir | path join $target
  }

  # Check if the path exists and open it with the editor
  if ($full_path | path exists) {
    let editor = $env.EDITOR

    # If the path is a file, open it in the editor directly
    # If the path is a directory, open the selected file in the editor
    if ($full_path | path type) == "file" {
      ^$editor $full_path
    } else if ($full_path | path type) == "dir" {
      cd $full_path
      fzf | if $in != null { ^$editor $in }
      cd $current_dir
    }
  } else {
    print $"Path ($full_path) does not exist."
  }
}

# zoxide
source "~/.zoxide.nu"

# Load platform specific config
const os_name = $nu.os-info.name
source $"./($os_name)/config.nu"
