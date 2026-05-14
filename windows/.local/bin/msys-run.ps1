<#
.SYNOPSIS
    Run MSYS2 commands within a PowerShell environment.
.DESCRIPTION
    This script allows you to execute MSYS2 commands directly from PowerShell. 
    It sets the MSYSRC environment variable to the provided argument, which specifies the command or script to run within the MSYS2 environment. After executing the MSYS2 shell command, it clears the MSYSRC variable to avoid unintended side effects on subsequent commands.
.EXAMPLE
    msys-run ls -la
    This command will run the 'ls -la' command within the MSYS2 environment, allowing you to list files in a directory with detailed information.
#>

$env:MSYSRC = "$args"
C:\msys64\msys2_shell.cmd -defterm -no-start -here -msys2
$env:MSYSRC = $null
