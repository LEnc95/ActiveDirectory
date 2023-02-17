#$stores =('0014','0040','0043','0047','0072','0228','1216','1620','4036','4086','5104','5107','6515','6520','6528','6539','6550')
#$UPN = @()
#$report= @()
#$results = @()
#$UPN = $stores | ForEach-Object {
#    "S"+$_+"GSO"
#}
#$report += $UPN | foreach-object {Get-ADUser $_ -Properties * | Select-Object SamAccountName, UserPrincipalName, Name, LastLogonDate}
#$report | Export-Csv -Path C:\Temp\MarketDistrict_info.csv -NoTypeInformation

#$results = $stores | foreach-object {
#    Get-ADUser -Filter {UserPrincipalName -like "*0014*"} -SearchBase "OU=Retail Users GPP,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com" -Properties SamAccountName, UserPrincipalName, Name, LastLogonDate | Select-Object SamAccountName, UserPrincipalName, Name, LastLogonDate
#}
$results = Get-ADUser -Filter {UserPrincipalName -like "*6550*"} -SearchBase "OU=Retail Users GPP,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com" -Properties SamAccountName, UserPrincipalName, Name, LastLogonDate | Select-Object SamAccountName, UserPrincipalName, Name, LastLogonDate
$results | Export-Csv -Path C:\Temp\MarketDistrict_results.csv -NoTypeInformation -Append