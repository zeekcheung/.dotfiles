# Setup script for Windows

$APPDATA = $Env:APPDATA
$LOCALAPPDATA = $Env:LOCALAPPDATA
$APPDATA = $Env:APPDATA
$LOCALAPPDATA = $Env:LOCALAPPDATA
$USERPROFILE = $Env:USERPROFILE

$Dotfiles = "$HOME\.dotfiles"
$Documents = [Environment]::GetFolderPath("MyDocuments")

# Symbolic link list: Target => Destination
$SymLinks = @{
  # git
  "$Dotfiles\git\.gitconfig" = "$USERPROFILE\.gitconfig"
  # clangd
  "$Dotfiles\clangd\.config\clangd\windows.config.yaml" = "$LOCALAPPDATA\clangd\config.yaml"
  # powershell
  "$Dotfiles\PowerShell\Documents\Microsoft.PowerShell_profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # windows terminal
  "$Dotfiles\WindowsTerminal\settings.json" = "$LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # neovim
  "$Dotfiles\nvim\.config\nvim" = "$LOCALAPPDATA\nvim"
  # lazygit
  "$Dotfiles\lazygit\.config\lazygit\config.yml" = "$LOCALAPPDATA\lazygit\config.yml"
  # fd
  "$Dotfiles\fd\.config\fd\ignore" = "$APPDATA\fd\ignore"
  # rime
  "$Dotfiles\fcitx5\.local\share\fcitx5\rime\default.custom.yaml" = "$APPDATA\Rime\default.custom.yaml"
  "$Dotfiles\fcitx5\.local\share\fcitx5\rime\rime_ice.custom.yaml" = "$APPDATA\Rime\rime_ice.custom.yaml"
}

# winget packages
$Packages = @(
  "Tencent.QQ.NT"
  "Tencent.QQMusic"
  "Tencent.WeChat.Universal"
  "Daum.PotPlayer"
  "Bandisoft.Bandizip"
  "voidtools.Everything"
  "XPDLS1XBTXVPP4"
  "Kingsoft.WPSOffice"
  # "Microsoft.Office"
  "Microsoft.OneDrive"
  "Microsoft.PowerToys"
  "Microsoft.WindowsTerminal"
  "Microsoft.VisualStudioCode"
  "Microsoft.VisualStudio.2022.Community"
  "9NBLGGH5R558" # Microsoft To Do
  "Neovim.Neovim"
  "ajeetdsouza.zoxide"
  "Schniz.fnm"
  "Python.Python.3.13"
  "AutoHotkey.AutoHotkey"
  "PremiumSoft.NavicatPremium"

  # packages from github
  "2dust.v2rayN"
  "Logitech.Options"
  "Notepad++.Notepad++"
  "Rime.Weasel"
  "RubyInstallerTeam.Ruby.3.2"
  "Obsidian.Obsidian"
  "Syncthing.Syncthing"
  "Microsoft.PowerShell"
  "Microsoft.WSL"
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
