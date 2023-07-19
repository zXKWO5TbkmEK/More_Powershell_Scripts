# Give SID as input to .NET Framework Class
$SID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-21-4256735972-1205184747-4227965648-30616")

# Use Translate to find user from sid
$objUser = $SID.Translate([System.Security.Principal.NTAccount])

# Print the converted SID to username value
$objUser.Value