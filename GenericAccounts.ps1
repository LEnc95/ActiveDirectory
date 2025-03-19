# Import the Active Directory module
Import-Module ActiveDirectory

# Search for accounts with UPN starting with 's' and ending with 'gso' in the specified format
$results = Get-ADUser -Filter {UserPrincipalName -like "s*psh@gianteagle.com" -or UserPrincipalName -like "s*gso@gianteagle.com" -or UserPrincipalName -like "s*srv@gianteagle.com"} -Properties UserPrincipalName

# Display the results
$results | Select-Object Name, UserPrincipalName | Where-Object UserPrincipalName -ne "saccpossrv@gianteagle.com"
