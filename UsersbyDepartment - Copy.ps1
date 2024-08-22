$site = "0047"
import-module activedirectory
Get-ADUser -Properties * -Filter {department -eq $site -and extensionAttribute3 -eq "A" -and extensionAttribute5 -eq "FIM Managed"} | Select msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName | Export-Csv -Path C:\Users\914476\Documents\GitHub\Reports\Users_$site.csv