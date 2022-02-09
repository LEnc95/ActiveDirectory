#Get-aduser -Filter {Name -like "*temp*"}
#$regex = "^d{4}$"
#$testdata = "Luke", "0008", "1219", "12le"
#$testdata | select-string -Pattern "^d{4}$"
#Select-String "$regex" -InputObject "$testdata" | get-member
$LDAPFilter = '(&'
$LDAPFilter += '((Name>=0)(Name<=9))'    #Name must start with a number
#$LDAPFilter += '(^d{4}$)'    #Name must start with a number
$LDAPFilter += ')'
$match = Get-ADgroup -searchbase "OU=DLs,OU=Exchange,DC=corp,DC=gianteagle,DC=com" -LDAPFilter $LDAPFilter
Write-host "found $($match.count) matches to filter: $ldapfilter"
$match | Export-Csv -path C:/temp/DLcleanup.csv
Write-host "C:/temp/DLcleanup.csv"