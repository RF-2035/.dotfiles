# ┌─────────────────────────────────────────────────────────┐
# │ ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 │
# └─────────────────────────────────────────────────────────┘

Invoke-Expression (&scoop-search --hook)
Import-Module -Name CompletionPredictor

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -EditMode Windows

# ┌────────────────┐
# │ Title & Prompt │
# └────────────────┘

function prompt {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $isHome = $PWD.Path -eq $HOME

    $user = if ($isAdmin) { "root@$($env:COMPUTERNAME): " } else { "$($env:USERNAME)@$($env:COMPUTERNAME): " }
    $folder = if ($isHome) { "~" } else { Split-Path $PWD -Leaf }
    $handle = if ($isAdmin) { "# " } else { "$ " }

    $host.UI.RawUI.WindowTitle = "$($PWD.Path.Replace($HOME, "~"))"
    return "$($PSStyle.Foreground.Green)$($PSStyle.Bold)${user}$($PSStyle.Foreground.Cyan)${folder}$($PSStyle.Reset)${handle}"
}

# ┌──────────────────────┐
# │ Colors (Light Theme) │
# └──────────────────────┘

Set-PSReadLineOption -Colors @{
  Command            = 'Black'
  Number             = 'DarkGray'
  Member             = 'DarkGray'
  Operator           = 'DarkGray'
  Type               = 'DarkGray'
  Variable           = 'Darkyellow'
  Parameter          = 'DarkYellow'
  ContinuationPrompt = 'DarkGray'
  Default            = 'DarkGray'
}

$host.privatedata.ErrorForegroundColor    = "Red"
$host.privatedata.ErrorBackgroundColor    = "White"
$host.privatedata.WarningForegroundColor  = "Yellow"
$host.privatedata.WarningBackgroundColor  = "White"
$host.privatedata.DebugForegroundColor    = "Yellow"
$host.privatedata.DebugBackgroundColor    = "White"
$host.privatedata.VerboseForegroundColor  = "Black"
$host.privatedata.VerboseBackgroundColor  = "White"
$host.privatedata.ProgressForegroundColor = "DarkGray"
$host.privatedata.ProgressBackgroundColor = "White"

$PSStyle.FileInfo.Directory  = $PSStyle.Background.BrightWhite + $PSStyle.Foreground.Black + $PSStyle.Bold
$PSStyle.FileInfo.Executable = $PSStyle.Background.BrightWhite + $PSStyle.Foreground.Black + $PSStyle.Bold

# ┌─────────┐
# │ Keymaps │
# └─────────┘

Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete

Remove-PSReadLineKeyHandler -Chord 'Ctrl+c'
Remove-PSReadLineKeyHandler -Chord 'Ctrl+v'

