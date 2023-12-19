# Give SID as input to .NET Framework Class
$SID = New-Object System.Security.Principal.SecurityIdentifier("SET SID HERE")

# Use Translate to find user from sid
$objUser = $SID.Translate([System.Security.Principal.NTAccount])

# Print the converted SID to username value
$objUser.Value
