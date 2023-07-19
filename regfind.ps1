# Prompt the user for input
$registryPath = Read-Host "Enter the registry path"
$regKeyValue = Read-Host "Enter the registry key value to check"

# Prompt the user to select the option
$option = Read-Host "Select an option:`n1. Check registry value`n2. Edit registry value"

try {
    if ($option -eq "1") {
        
        # Prompt the user for the path to the TXT/CSV file
        $fileType = Read-Host "Enter the type of file (TXT/CSV)"
        $filePath = Read-Host "Enter the path to the $fileType file"

        # Read the computer names from the file
        $computerNames = switch ($fileType.ToUpper()) {
            "TXT" { Get-Content $filePath }
            "CSV" { Import-Csv $filePath | ForEach-Object { $_.ComputerName } }
            default { throw "Invalid file type. Only TXT and CSV files are supported." }
        }

        # Define the command to execute on the remote computer
        $scriptBlock = {
            param($path, $value)
            $regValue = Get-ItemProperty -Path $path | Select-Object -ExpandProperty $value
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                RegistryPath = $path
                RegistryValue = $regValue
            }
        }

        # Invoke the command on each remote computer
        $results = Invoke-Command -ComputerName $computerNames -ScriptBlock $scriptBlock -ArgumentList $registryPath, $regKeyValue

        # Output the results
        $results | Format-Table

        # Logging
        $logMessage = "Registry check performed on $($results.Count) computers. Registry path: $registryPath, Registry value: $regKeyValue"
        Add-Content -Path "log.txt" -Value $logMessage
    }
    elseif ($option -eq "2") {

        # Prompt the user for the path to the TXT/CSV file
        $fileType = Read-Host "Enter the type of file (TXT/CSV)"
        $filePath = Read-Host "Enter the path to the $fileType file"

        # Read the computer names from the file
        $computerNames = switch ($fileType.ToUpper()) {
            "TXT" { Get-Content $filePath }
            "CSV" { Import-Csv $filePath | ForEach-Object { $_.ComputerName } }
            default { throw "Invalid file type. Only TXT and CSV files are supported." }
        }

        # Prompt the user for the new registry value
        $newRegValue = Read-Host "Enter the new registry value"

        # Define the command to execute on the remote computer
        $scriptBlock = {
            param($path, $value, $newValue)
            Set-ItemProperty -Path $path -Name $value -Value $newValue -Force
            $regValue = Get-ItemProperty -Path $path | Select-Object -ExpandProperty $value
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                RegistryPath = $path
                RegistryValue = $regValue
            }
        }

        # Confirm if the user wants to edit the registry value
        $confirm = Read-Host "Are you sure you want to edit the registry value on the selected machines? (Y/N)"
        if ($confirm -eq "Y" -or $confirm -eq "y") {

            # Invoke the command on each remote computer
            $results = Invoke-Command -ComputerName $computerNames -ScriptBlock $scriptBlock -ArgumentList $registryPath, $regKeyValue, $newRegValue

            # Output the results
            $results | Format-Table

            # Logging
            $logMessage = "Registry value edited on $($results.Count) computers. Registry path: $registryPath, Registry value: $regKeyValue, New value: $newRegValue"
            Add-Content -Path "log.txt" -Value $logMessage
        }
        else {
            Write-Host "Registry value editing cancelled."

            # Logging
            $logMessage = "Registry value editing cancelled."
            Add-Content -Path "log.txt" -Value $logMessage
            return
        }
    }
    else {
        Write-Host "Invalid option selected."

        # Logging
        $logMessage = "Invalid option selected."
        Add-Content -Path "log.txt" -Value $logMessage
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red

    # Logging
    $errorMessage = "An error occurred: $_"
    Add-Content -Path "log.txt" -Value $errorMessage
}
