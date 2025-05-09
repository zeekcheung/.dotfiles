# Setup script for Windows

$Dotfiles = "$HOME\.dotfiles"
$Documents = [Environment]::GetFolderPath("MyDocuments")

# Symbolic link list: Target => Destination
$SymLinks = @{
  # git
  "$Dotfiles\git\.gitconfig"                                        = "$Env:USERPROFILE\.gitconfig"
  # rime
  "$Dotfiles\rime\.local\share\fcitx5\rime\default.custom.yaml"   = "$Env:APPDATA\Rime\default.custom.yaml"
  "$Dotfiles\rime\.local\share\fcitx5\rime\weasel.custom.yaml"    = "$Env:APPDATA\Rime\weasel.custom.yaml"
  "$Dotfiles\rime\.local\share\fcitx5\rime\rime_ice.custom.yaml"  = "$Env:APPDATA\Rime\rime_ice.custom.yaml"
  # windows terminal
  "$Dotfiles\WindowsTerminal\settings.json"                         = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # powershell
  "$Dotfiles\PowerShell\Documents\Microsoft.PowerShell_profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # starship
  "$Dotfiles\starship\.config\starship.toml"                        = "$HOME\.config\starship.toml"
  # lazygit
  "$Dotfiles\lazygit\.config\lazygit\config.yml"                    = "$Env:LOCALAPPDATA\lazygit\config.yml"
  # fd
  "$Dotfiles\fd\.config\fd\ignore"                                  = "$Env:APPDATA\fd\ignore"
  # neovim
  "$Dotfiles\nvim\.config\nvim"                                     = "$Env:LOCALAPPDATA\nvim"
  # clangd
  "$Dotfiles\clangd\.config\clangd\windows.config.yaml"             = "$Env:LOCALAPPDATA\clangd\config.yaml"
}

# winget packages
$Packages = @(
  "Tencent.QQ.NT"
  "Tencent.QQMusic"
  "Tencent.WeChat.Universal"
  "Daum.PotPlayer"
  "voidtools.Everything"
  "XPDLS1XBTXVPP4" # Wise Registry Cleaner
  # "Kingsoft.WPSOffice"
  "Microsoft.Office"
  "Microsoft.OneDrive"
  "Microsoft.PowerToys"
  "Microsoft.WindowsTerminal"
  "Microsoft.VisualStudioCode"
  "Microsoft.VisualStudio.2022.Community"
  "9NBLGGH5R558" # Microsoft To Do
  "Neovim.Neovim"
  "ajeetdsouza.zoxide"
  "Schniz.fnm"
  # "Python.Python.3.13"
  "PremiumSoft.NavicatPremium"
)

# packages from github
$GithubPackages=@(
  # "2dust.v2rayN"
  "Logitech.Options"
  "Notepad++.Notepad++"
  "Rime.Weasel"
  "RubyInstallerTeam.Ruby.3.2"
  "Obsidian.Obsidian"
  "Syncthing.Syncthing"
  "Microsoft.PowerShell"
  "Microsoft.WSL"
  "Starship.Starship"
  "eza-community.eza"
  "junegunn.fzf"
  "sharkdp.fd"
  "sharkdp.bat"
  "JesseDuffield.lazygit"
  "EMQ.MQTTX"
)

# Install packages
Write-Host "Installing packages..."
foreach ($Package in $Packages) {
  winget install --id $Package
}

# Install packages from github
foreach ($Package in $GithubPackages) {
  winget install --id $Package --proxy http://127.0.0.1:10808
}

# Refresh Path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($Symlink in $SymLinks.GetEnumerator()) {
  $Target = $Symlink.Key
  $Destination = $Symlink.Value

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}
