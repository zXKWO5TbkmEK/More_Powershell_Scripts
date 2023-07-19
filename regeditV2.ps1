$LogFile = "C:\_PersonalStuff\MyScript.log"

# Function to write log messages to the log file
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "Info"
    )

    $DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "$DateTime [$Level] $Message"
    Add-Content -Path $LogFile -Value $LogMessage
}

# Trap the Ctrl+C key combination to ensure script termination
$null = $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(150, 50)
$null = $host.UI.RawUI.WindowTitle = "MyScript"

function Stop-Script {
    Write-Log -Message "Script terminated by user."
    exit
}

trap {
    Write-Log -Message "An error occurred: $($_.Exception.Message)" -Level "Error"
    exit
}

try {
    # Prompt the user for input
    Write-Host "Enter the registry path"
    $registryPath = Read-Host

    Write-Host "Enter the registry key value to check"
    $regKeyValue = Read-Host

    # Prompt the user to select the option
    Write-Host "Select an option:`n1. Check registry value`n2. Edit registry value"
    $option = Read-Host

    if ($option -eq "1") {
        # Rest of the code for checking registry value
        Write-Host "Checking registry value..."
        Write-Log -Message "Checking registry value: $registryPath\$regKeyValue"
        
        # Perform the registry value check
        # ...
    }
    elseif ($option -eq "2") {
        # Rest of the code for editing registry value
        Write-Host "Enter the new registry value"
        $newRegValue = Read-Host

        Write-Host "Editing registry value..."
        Write-Log -Message "Editing registry value: $registryPath\$regKeyValue with new value: $newRegValue"
        
        # Perform the registry value edit
        # ...
    }
    else {
        Write-Host "Invalid option selected."
        Write-Log -Message "Invalid option selected." -Level "Error"
        exit
    }
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Host "An error occurred: $errorMessage" -ForegroundColor Red
    Write-Log -Message "An error occurred: $errorMessage" -Level "Error"
    exit
}
finally {
    # Log script completion
    Write-Log -Message "Script execution completed."
}
