$Host.UI.RawUI.WindowTitle = ""
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# Enhance command suggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function AcceptSuggestion

# Global variables: $Config, $Documents, etc
$Global:Config = $HOME + "\.config"
$Global:Documents = [Environment]::GetFolderPath("MyDocuments")
$Global:Downloads = (New-Object -ComObject Shell.Application).Namespace("shell:Downloads").Self.Path
$Global:Music = [Environment]::GetFolderPath("MyMusic")
$Global:Pictures = [Environment]::GetFolderPath("MyPictures")
$Global:Videos = [Environment]::GetFolderPath("MyVideos")

# Environment variables
$Env:EDITOR = "nvim"

$Env:FZF_DEFAULT_OPTS = "
  --ansi
  --cycle
  --reverse
  --border
  --height=100%
  --preview='bat --color=always {}'
  --preview-window='right,50%,border-left,<50(down,50%,border-up)'
  --color=bg:-1
  --color=gutter:-1
"

fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

$Env:FNM_MULTISHELL_PATH = "$Env:LOCALAPPDATA\fnm_multishells\17184_1745943454228"
$Env:FNM_VERSION_FILE_STRATEGY = "local"
$Env:FNM_DIR = "$Env:APPDATA\fnm"
$Env:FNM_LOGLEVEL = "info"
$Env:FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$Env:FNM_COREPACK_ENABLED = "true"
$Env:FNM_RESOLVE_ENGINES = "true"
$Env:FNM_ARCH = "x64"

# Aliases
Set-Alias alias Set-Alias
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer
Set-Alias vi nvim

function .. { Set-Location .. }
function env { Get-ChildItem -Path 'Env:' }
function path { $Env:Path -split ';' }
function reload { & $PROFILE }

function ln {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Target,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination
  )

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}

function touch {
  param(
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [String[]]$Paths
  )

  process {
    foreach ($Path in $Paths) {
      $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($Path)
      $parentDirectory = Split-Path -Path $expandedPath -Parent

      if (-not [string]::IsNullOrWhiteSpace($parentDirectory) -and -not (Test-Path -Path $parentDirectory)) {
        $null = New-Item -Path $parentDirectory -ItemType Directory
      }

      if (Test-Path -Path $expandedPath) {
        $currentDate = Get-Date
        $null = (Get-Item -Path $expandedPath).LastWriteTime = $currentDate
        $null = (Get-Item -Path $expandedPath).LastAccessTime = $currentDate
      }
      else {
        $null = New-Item -Path $expandedPath -ItemType File
      }
    }
  }
}

function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function Remove-DefaultAlias {
  param ($name, $scope = 'Global')
  if (Get-Alias $name -ErrorAction SilentlyContinue) {
    Remove-Alias -Name $name -Scope $scope -Force
  }
}

Remove-DefaultAlias ls
function ls { eza --color=always --sort=Name --group-directories-first $args }
function la { ls -a }
function ll { ls -l }
function l { ls -la }
function tree { eza --color=always --tree $args }

Remove-DefaultAlias cat
function cat { bat -p $args }

function f { fzf $args }

Remove-DefaultAlias gc
Remove-DefaultAlias gp
function ga { git add $args }
function gb { git branch $args }
function gc { git commit $args }
function gcm { git commit -m $args }
function gca { git commit --amend --no-edit $args }
function gco { git checkout $args }
function gd { git diff $args }
function gl { git log $args }
function gf { git fetch $args }
function gpl { git pull $args }
function gps { git push $args }
function gpsf { git push --force $args }
function gr { git rebase $args }
function grc { git rebase --continue $args }
function gri { git rebase --interactive $args }
function gst { git status }
Set-Alias gg lazygit

function diff { nvim -d $args }

function Get-GitBranch {
  # Check if the current directory is a Git repository
  if (Test-Path -Path ".git" -PathType Container) {
    try {
      # Retrieve the name of the current branch
      $branchName = git symbolic-ref --short HEAD
      if ($branchName) {
        return " on  $branchName"
      }
    }
    catch {
      # Handle any errors silently
    }
  }
  return ""
}

# custom prompt
$firstPrompt = $true
function prompt {
  $user = $Env:USERNAME
  $dir = Get-Location
  $gitBranch = Get-GitBranch

  # Define colors
  $userColor = "Yellow"
  $dirColor = "Cyan"
  $branchColor = "Magenta"
  $promptSymbolColor = "Green"
  $textColor = "White"

  # Add a newline before the prompt for subsequent prompts
  if ($firstPrompt) {
    $global:firstPrompt = $false
  }
  else {
    Write-Host ""
  }

  # Format prompt components with colors
  Write-Host "$user " -NoNewLine  -ForegroundColor $userColor
  Write-Host "in " -NoNewLine -ForegroundColor $textColor
  if ($gitBranch -ne '') {
    Write-Host "$dir" -NoNewLine -ForegroundColor $dirColor
    Write-Host "$gitBranch" -ForegroundColor $branchColor
  }
  else {
    Write-Host "$dir" -ForegroundColor $dirColor
  }
  Write-Host '❯' -NoNewLine -ForegroundColor $promptSymbolColor

  return " "
}

# Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Alias -Name cd -Scope Global -Force
Set-Alias cd z -Scope Global -Force
