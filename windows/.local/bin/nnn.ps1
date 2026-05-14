<#
.SYNOPSIS
    nnn — The unorthodox terminal file manager, run within the MSYS2 environment.
.DESCRIPTION
    nnn (Nnn's Not Noice) is a performance-optimized, feature-packed fork of noice http://git.2f30.org/noice/ with seamless desktop integration, simplified navigation, type-to-nav mode with dir auto-enter, disk usage analyzer mode, bookmarks, contexts, application launcher, familiar navigation shortcuts, subshell spawning and much more. It remains a simple and efficient file manager that stays out of your way.

    nnn opens the current working directory if PATH is not specified. If PATH is specified and it exists, nnn will open it. If the PATH doesn't exist and ends with a /, nnn will attempt to create the directory tree and open it. Otherwise, PATH is considered a path to a regular file and nnn attempts to create the complete directory tree to the file, open the parent directory and prompt to create the new file in it with the base filename.
.EXAMPLE
    nnn
    This command will open nnn in the current working directory.
.EXAMPLE
    nnn /c/Users/YourUsername/Documents
    This command will open nnn in the specified directory.
.EXAMPLE
    nnn /c/Users/YourUsername/Documents/NewFile.txt
    This command will create the directory tree to the file if it doesn't exist, open the parent directory in nnn, and prompt to create the new file.
#>

$env:MSYSRC = "nnn $args"
C:\msys64\msys2_shell.cmd -defterm -no-start -here -msys2
$env:MSYSRC = $null
