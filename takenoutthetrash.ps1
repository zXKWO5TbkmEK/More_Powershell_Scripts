<#
.SYNOPSIS
    Purges Temp directory and AppData folder(s) incase of weird issues with programs.
.DESCRIPTION
    Low 
#>
@echo off
#Purge Temp Directory
Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse

#Backup Appdata locally and purge Appdata for current signed in user
echo This will take some time
$env:Source="C:\Users\$env:username\AppData\" 
Robocopy $env:Source C:\appdatabackup /s /b
$env:Source="C:\Users\$env:username\AppData\" | Remove-Item -Force -Recurse
