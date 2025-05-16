# Setup script for Windows

$Dotfiles = "$HOME\.dotfiles"
$Documents = [Environment]::GetFolderPath("MyDocuments")

# Symbolic link list: Target => Destination
$SymLinks = @{
  # ssh
  "$Dotfiles\ssh\.ssh\config"                                                = "$env:USERPROFILE\.ssh\config"
  # git
  "$Dotfiles\git\.gitconfig"                                                 = "$env:USERPROFILE\.gitconfig"
  # rime
  "$Dotfiles\rime\.local\share\fcitx5\rime\default.custom.yaml"              = "$env:APPDATA\Rime\default.custom.yaml"
  "$Dotfiles\rime\.local\share\fcitx5\rime\rime_ice.custom.yaml"             = "$env:APPDATA\Rime\rime_ice.custom.yaml"
  "$Dotfiles\rime\.local\share\fcitx5\rime\weasel.custom.yaml"               = "$env:APPDATA\Rime\weasel.custom.yaml"
  # wezterm
  "$Dotfiles\wezterm\.config\wezterm\wezterm.lua"                            = "$HOME\.config\wezterm\wezterm.lua"
  # windows terminal
  "$Dotfiles\wt\settings.json"                                               = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # powershell
  "$Dotfiles\powershell\.config\powershell\Microsoft.PowerShell_profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # nushell
  "$Dotfiles\nushell\.config\nushell\config.nu"                              = "$env:APPDATA\nushell\config.nu"
  "$Dotfiles\nushell\.config\nushell\env.nu"                                 = "$env:APPDATA\nushell\env.nu"
  "$Dotfiles\nushell\.config\nushell\windows\config.nu"                      = "$env:APPDATA\nushell\windows\config.nu"
  "$Dotfiles\nushell\.config\nushell\windows\env.nu"                         = "$env:APPDATA\nushell\windows\env.nu"
  # starship
  "$Dotfiles\starship\.config\starship.toml"                                 = "$HOME\.config\starship.toml"
  # lazygit
  "$Dotfiles\lazygit\.config\lazygit\config.yml"                             = "$env:LOCALAPPDATA\lazygit\config.yml"
  # fd
  "$Dotfiles\fd\.config\fd\ignore"                                           = "$env:APPDATA\fd\ignore"
  # neovim
  "$Dotfiles\nvim\.config\nvim"                                              = "$env:LOCALAPPDATA\nvim"
  # neovide
  "$Dotfiles\neovide\.config\neovide\config.toml"                            = "$env:APPDATA\neovide\config.toml"
  # wsl
  "$Dotfiles\wsl\.wslconfig"                                                 = "$env:USERPROFILE\.wslconfig"
}

# winget packages
$Packages = @(
  "Tencent.QQ.NT"
  "Tencent.QQMusic"
  "Tencent.WeChat.Universal"
  "Daum.PotPlayer"
  "voidtools.Everything"
  "XPDLS1XBTXVPP4"
  "Microsoft.Office"
  "Microsoft.OneDrive"
  "Microsoft.PowerToys"
  "Microsoft.WindowsTerminal"
  "Microsoft.VisualStudioCode"
  "9NBLGGH5R558" # Microsoft To Do
  "Neovim.Neovim"
  "ajeetdsouza.zoxide"
)

# packages from github
$GithubPackages = @(
  # packages from github
  # "2dust.v2rayN"
  "Logitech.Options"
  "Notepad++.Notepad++"
  "Obsidian.Obsidian"
  "Syncthing.Syncthing"
  # "Microsoft.WSL"
  "Microsoft.PowerShell"
  "Nushell.Nushell"
  "rsteube.Carapace"
  "wez.wezterm"
  "Starship.Starship"
  "eza-community.eza"
  "junegunn.fzf"
  "sharkdp.fd"
  "sharkdp.bat"
  "JesseDuffield.lazygit"
  "SQLite.SQLite"
)

# Install packages
Write-Host "Installing packages..."
foreach ($Package in $Packages)
{
  winget install --id $Package
}

# Install packages from github
foreach ($Package in $GithubPackages)
{
  winget install --id $Package --proxy http://127.0.0.1:10808
}

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($Symlink in $SymLinks.GetEnumerator())
{
  $Target = $Symlink.Key
  $Destination = $Symlink.Value

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}

