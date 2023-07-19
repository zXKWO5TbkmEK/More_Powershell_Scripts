$computer = Read-Host -Prompt "Enter Computer Name Here";
If (Test-Connection -ComputerName $computer -Count 2 -Quiet) {
    Write-Host "The computer responded to our ping request. Connecting...";
    Invoke-Command -ComputerName $computer -ScriptBlock {
        $credential = Get-Credential -UserName "Administrator" -Message "Enter new password";
        If ($credential -eq $null) {
            Write-Warning "The username and/or the password is empty! I quit.";
            Exit;
        }
        Set-LocalUser -Name $credential.UserName -Password $credential.Password;
    }
} Else {
    Write-Warning "The computer does not respond to our ping request. I quit.";
}