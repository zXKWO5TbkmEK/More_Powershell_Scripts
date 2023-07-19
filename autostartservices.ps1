<#
.SYNOPSIS
    Starts services that are not running that are helpful to end users (and IT in general).
.DESCRIPTION
    Fixes common issues
#>

#Starts AnyConnect service and sets to autostart
Set-Service vpnagent -StartupType Automatic
Start-Service vpnagent

#Starts Umbrella Roaming Client and sets to autostart
Set-Service Umbrella_RC -StartupType Automatic
Start-Service Umbrella_RC

#Starts FileOpen Manager and sets to autostart
Set-Service FileOpenManager -StartupType Automatic
Start-Service FileOpenManager

#Starts TightVNC Server and sets to autostart
Set-Service tvnserver -StartupType Automatic
Start-Service tvnserver

#Starts Netlogon and sets to autostart
Set-Service Netlogon -StartupType Automatic
Start-Service Netlogon

