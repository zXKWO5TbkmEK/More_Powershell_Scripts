$computer = Get-WmiObject Win32_ComputerSystem

$computer.UnjoinDomainOrWorkGroup("PASSWORD", "USERNAME", 0)

$computer.JoinDomainOrWorkGroup("DOMAIN", "PASSWORD", "USERNAME", $null, 3)

Restart-Computer -Force
