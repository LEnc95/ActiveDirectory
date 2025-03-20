# Get the Distinguished Names for the OUs
$ou1 = Get-ADOrganizationalUnit -Filter {Name -eq "Alpha II"} | Select-Object -ExpandProperty DistinguishedName
$ou2 = Get-ADOrganizationalUnit -Filter {Name -eq "Chestnut Ridge"} | Select-Object -ExpandProperty DistinguishedName

Write-Host "DN for Alpha II: $ou1"
Write-Host "DN for Chestnut Ridge: $ou2"

# Get users from the Alpha II OU
$usersAlphaII = Get-ADUser -Filter * -SearchBase $ou1 -Properties DisplayName, SamAccountName, UserPrincipalName, Enabled, LastLogonDate

# Get users from the Chestnut Ridge OU
$usersChestnutRidge = Get-ADUser -Filter * -SearchBase $ou2 -Properties DisplayName, SamAccountName, UserPrincipalName, Enabled, LastLogonDate

$allUsers = @()  # Initialize an empty array
$allUsers += $usersAlphaII  # Add users from Alpha II OU
$allUsers += $usersChestnutRidge  # Add users from Chestnut Ridge OU

# Export to CSV
$allUsers | Select-Object DisplayName, SamAccountName, UserPrincipalName, Enabled, LastLogonDate | Export-Csv -Path "C:\temp\users_report.csv" -NoTypeInformation

Write-Host "Report generated and saved to C:\temp\users_report.csv"
