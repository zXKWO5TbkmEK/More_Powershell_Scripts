$computer = Get-WmiObject Win32_ComputerSystem

$computer.UnjoinDomainOrWorkGroup("kiYHVVvqMb7", "marshall.cook@orchid-ortho.com", 0)

$computer.JoinDomainOrWorkGroup("orchid.lan", "kiYHVVvqMb7", "marshall.cook@orchid-ortho.com", $null, 3)

Restart-Computer -Force