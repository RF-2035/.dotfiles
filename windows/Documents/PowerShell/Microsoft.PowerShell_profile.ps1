# ┌─────────────────────────────────────────────────────────┐
# │ ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 │
# └─────────────────────────────────────────────────────────┘

Invoke-Expression (&scoop-search --hook)
Import-Module -Name CompletionPredictor

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -EditMode Windows

function prompt {
    $host.UI.RawUI.WindowTitle = "$($PWD.Path.Replace($HOME, "~"))"
    if ($PWD.Path -eq $HOME) {
        Write-Host "`e[32;1m$($env:USERNAME)@$($env:COMPUTERNAME): `e[36m~`e[0m" -NoNewline
    } else {
        Write-Host "`e[32;1m$($env:USERNAME)@$($env:COMPUTERNAME): `e[36m$(Split-Path $PWD -Leaf)`e[0m" -NoNewline
    }
    return "$ "
}

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

Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete

function nnn {
    ucrt64
}
