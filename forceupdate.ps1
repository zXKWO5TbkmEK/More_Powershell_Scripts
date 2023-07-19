function Invoke-ConfigMgrClientAction
{
<#
.SYNOPSIS
Initiates SCCM client policy evaluations on the specified machine(s).

.DESCRIPTION
This cmdlet manually triggers the WMI schedules that correspond to SCCM ConfigMgr client actions and policy evaluations.

    Software Update Scan Cycle
    Discovery Data Inventory
    Hardware Inventory Collection
    Machine Policy Evaluation
    Software Update Evaluation Cycle
    Send Unsent State Messages
    Machine Policy Assignments
    Application Deployment Evaluation
.PARAMETER ComputerName
The name or IP address of the machine(s) to intiate SCCM client policy evaluations on. No value defaults to localhost
.PARAMETER Actions
The client actions you would like to trigger the specified machine to perform. Below are the valid options:

    SoftwareUpdateScanCycle
    DiscoveryInventory
    HardwareInventoryCollection
    MachinePolicies
    SoftwareUpdateEvaluationCycle
    SendUnsentStateMessages
    MachineAssignments
    ApplicationPolicy

You can provide more than one option as well, separating them with a comma. If this parameter is not specified, all of the above actions will be run.
.PARAMETER Credential
Specifies the credential to use for the remote operations. Defaults to the $ElevatedCredentials variable if defined/already set.
.EXAMPLE
Invoke-ConfigMgrClientAction -ComputerName COMPUTER1

Immediately runs all SCCM client actions on COMPUTER1.
.EXAMPLE
Invoke-ConfigMgrClientAction -ComputerName COMPUTER1 -ACtions MachinePolicies,ApplicationPolicy

Immediately runs only the Machine and Application policy evaluation cycle SCCM client actions on COMPUTER1.
.OUTPUTS
Returns only host/text output confirming the actions were successful.
.NOTES
Author: Taylor Harris

Initiating policy evaluations does not wait for them to complete. It only informs the client to run them as soon as possible. It will usually take a minute or two for the policy evaluations to actually complete, though in the case of software update cycles, even longer.
#>

[cmdletbinding()]
Param
(
    [Parameter(Mandatory=$False,ValueFromPipeline=$True)]
    [string[]]$ComputerName = "localhost",

    [Parameter(Mandatory=$False,ValueFromPipeline=$False)]
    [ValidateSet('SoftwareUpdateScanCycle','DiscoveryInventory','HardwareInventoryCollection','MachinePolicies','SoftwareUpdateEvaluationCycle','SendUnsentStateMessages','MachineAssignments','ApplicationPolicy')]
    [string[]]$Actions = @('SoftwareUpdateScanCycle','DiscoveryInventory','HardwareInventoryCollection','MachinePolicies','SoftwareUpdateEvaluationCycle','SendUnsentStateMessages','MachineAssignments','ApplicationPolicy'),

    [Parameter(Mandatory=$False)]
    [PSCredential]$Credential
)

    Begin
    {
        $ClientActions = @{
            'DiscoveryInventory'='{00000000-0000-0000-0000-000000000003}';
            'MachineAssignments'='{00000000-0000-0000-0000-000000000021}';
            'MachinePolicies'='{00000000-0000-0000-0000-000000000022}';
            'ApplicationPolicy'='{00000000-0000-0000-0000-000000000121}';
            'HardwareInventoryCollection'='{00000000-0000-0000-0000-000000000001}';
            'SoftwareUpdateEvaluationCycle'='{00000000-0000-0000-0000-000000000108}';
            'SoftwareUpdateScanCycle'='{00000000-0000-0000-0000-000000000113}';
            'SendUnsentStateMessages'='{00000000-0000-0000-0000-000000000111}'
        }

        $jobs = @()
    }

    Process
    {
        $jobs += Invoke-Command -ComputerName $ComputerName -Credential:$Credential -Authentication Default -ScriptBlock {
            $VerbosePreference = $using:VerbosePreference
            $ClientActions = $using:ClientActions
            $Actions = $using:Actions

            try
            {
                foreach ($action in $Actions)
                {
                    Write-Verbose "Triggering SCCM client action: '$action' with schedule: '$($ClientActions.$action)'"
                    Invoke-WMIMethod -Namespace "Root\CCM" -Class SMS_CLIENT -Name TriggerSchedule -ArgumentList $ClientActions.$action -ErrorAction Stop | Out-String | Write-Debug
                }

                Write-Host "[$env:COMPUTERNAME]: Successfully triggered requested ConfigMgr client actions" -ForegroundColor Green
            }
            catch
            {
                Write-Host "[$env:COMPUTERNAME] ERROR: $_" -ForegroundColor Red
            }
        } -AsJob
    }

    End
    {
        $jobs | Receive-Job -Wait
    }
}