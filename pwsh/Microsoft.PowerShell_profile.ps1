Invoke-Expression (&scoop-search --hook)
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/robbyrussell.omp.json" | Invoke-Expression

Import-Module -Name CompletionPredictor

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -EditMode Windows

Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete

Set-Alias lvim 'C:\Users\User\.local\bin\lvim.ps1'

# setup clash meta proxy
# $env:HTTP_PROXY="http://127.0.0.1:7897"; $env:HTTPS_PROXY="http://127.0.0.1:7897"

# nnn opens msys2 instead of file manager
function nnn {
    ucrt64
}
