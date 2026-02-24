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
  # komorebi
  "$Dotfiles\komorebi\komorebi.json"                                         = "$env:USERPROFILE\komorebi.json"
  "$Dotfiles\komorebi\komorebi.bar.json"                                     = "$env:USERPROFILE\komorebi.bar.json"
  "$Dotfiles\komorebi\.config\whkdrc"                                        = "$env:USERPROFILE\.config\whkdrc"
  # ideavim
  "$Dotfiles\ideavim\.ideavimrc"                                             = "$env:USERPROFILE\.ideavimrc"
  # visual studio
  "$Dotfiles\vs\_vsvimrc"                                                    = "$HOME\_vsvimrc"
  # mactype
  "$Dotfiles\mactype\lcd-subpixel.ini"                                       = "$env:PROGRAMFILES\Mactype\ini\lcd-subpixel.ini"
}

# winget packages
$Packages = @(
  "Tencent.WeChat.Universal"
  "Tencent.QQ.NT"
  "Tencent.QQMusic"
  "Daum.PotPlayer"
  "ClashVergeRev.ClashVergeRev"
  # "2dust.v2rayN"
  "7zip.7zip"
  "GnuWin32.Gzip"
  "voidtools.Everything"
  "9NBLGGH5R558" # Microsoft To Do
  # "Obsidian.Obsidian"
  # "Syncthing.Syncthing"
  # "Logitech.Options"
  # "XPDLS1XBTXVPP4" # Wise Registry Cleaner
  "Microsoft.PowerToys"
  "ZedIndustries.Zed"
  "Neovim.Neovim"
  "Rime.Weasel"
  "Microsoft.WindowsTerminal"
  "Microsoft.PowerShell"
  "Nushell.Nushell"
  "rsteube.Carapace"
  "Starship.Starship"
  "ajeetdsouza.zoxide"
  "eza-community.eza"
  "junegunn.fzf"
  "sharkdp.fd"
  "sharkdp.bat"
  "BurntSushi.ripgrep.MSVC"
  "JesseDuffield.lazygit"
  "Schniz.fnm"
  "Python.Python.3.13"
  "GoLang.Go"
  "zig.zig"
  "BrechtSanders.WinLibs.POSIX.UCRT"
  # "SQLite.SQLite"
)

# Install packages
Write-Host "Installing packages..."
foreach ($Package in $Packages)
{
  # winget install --id $Package
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
