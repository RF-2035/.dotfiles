<#
.SYNOPSIS
    Sets an environment variable and automatically refreshes the current session.

.DESCRIPTION
    Sets an environment variable using sequential arguments for Name and Value, 
    and switch tags (-Process, -User, -Machine) to define the scope. 
    If a User or Machine variable is set, it automatically refreshes the current 
    PowerShell session to apply the changes immediately.

    You can also use the -Refresh switch by itself to just reload variables from the registry.

.EXAMPLE
    .\setenv.ps1 -User MY_VAR HelloWorld
.EXAMPLE
    .\setenv.ps1 -Machine GLOBAL_CONFIG "C:\Config"
.EXAMPLE
    .\setenv.ps1 -Refresh
#>

[CmdletBinding(DefaultParameterSetName='User')]
param (
    [Parameter(ParameterSetName='Process')]
    [switch]$Process,

    [Parameter(ParameterSetName='User')]
    [switch]$User,

    [Parameter(ParameterSetName='Machine')]
    [switch]$Machine,

    [Parameter(Mandatory=$true, ParameterSetName='RefreshOnly')]
    [switch]$Refresh,

    [Parameter(Mandatory=$true, Position=0, ParameterSetName='Process')]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName='User')]
    [Parameter(Mandatory=$true, Position=0, ParameterSetName='Machine')]
    [string]$Name,

    [Parameter(Mandatory=$true, Position=1, ParameterSetName='Process')]
    [Parameter(Mandatory=$true, Position=1, ParameterSetName='User')]
    [Parameter(Mandatory=$true, Position=1, ParameterSetName='Machine')]
    [string]$Value
)

# --- Helper Function: Refresh Current Session ---
function Update-CurrentSession {
    Write-Host "Refreshing current session variables from registry..." -NoNewline -ForegroundColor Cyan

    $originalUserName = $env:USERNAME
    $originalArchitecture = $env:PROCESSOR_ARCHITECTURE

    $machineKey = "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
    $userKey    = "HKCU:\Environment"

    $machineVars = Get-ItemProperty -Path $machineKey
    $userVars    = Get-ItemProperty -Path $userKey

    $excludeProps = @("PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")

    # Apply Machine Variables
    foreach ($var in $machineVars.psobject.properties) {
        if ($var.Name -notin $excludeProps -and $var.Name -notmatch '^Path$') {
            [Environment]::SetEnvironmentVariable($var.Name, $var.Value, "Process")
        }
    }

    # Apply User Variables (Overwrites Machine vars on conflict)
    foreach ($var in $userVars.psobject.properties) {
        if ($var.Name -notin $excludeProps -and $var.Name -notmatch '^Path$') {
            [Environment]::SetEnvironmentVariable($var.Name, $var.Value, "Process")
        }
    }

    # Handle PATH
    $machinePath = $machineVars.Path
    $userPath    = $userVars.Path
    $newPath = "$machinePath;$userPath" -replace ';;+', ';' 
    $newPath = $newPath.TrimEnd(';')
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Process")

    # Reset user / architecture
    [Environment]::SetEnvironmentVariable("USERNAME", $originalUserName, "Process")
    [Environment]::SetEnvironmentVariable("PROCESSOR_ARCHITECTURE", $originalArchitecture, "Process")

    Write-Host " Done." -ForegroundColor Green
}
# ------------------------------------------------

try {
    # If the user just wants to refresh, do that and exit
    if ($Refresh) {
        Update-CurrentSession
        return
    }

    # Otherwise, determine the scope based on the active switch
    $scopeName = "User" # Default
    $targetScope = [System.EnvironmentVariableTarget]::User

    if ($Process) {
        $scopeName = "Process"
        $targetScope = [System.EnvironmentVariableTarget]::Process
    } elseif ($Machine) {
        $scopeName = "Machine"
        $targetScope = [System.EnvironmentVariableTarget]::Machine
    }

    # Set the environment variable
    [Environment]::SetEnvironmentVariable($Name, $Value, $targetScope)

    Write-Host "Successfully set environment variable!" -ForegroundColor Green
    Write-Host "Name:  $Name"
    Write-Host "Value: $Value"
    Write-Host "Scope: $scopeName`n"

    # If it was saved to the registry, automatically pull it into the current session
    if ($scopeName -in @("Machine", "User")) {
        Update-CurrentSession
    }
}
catch {
    Write-Error "Failed to set environment variable. If you are using the '-Machine' tag, ensure you are running PowerShell as Administrator."
    Write-Error $_.Exception.Message
}
