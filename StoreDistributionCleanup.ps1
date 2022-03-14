#Get-aduser -Filter {Name -like "*temp*"}
#$regex = "^d{4}$"
#$testdata = "Luke", "0008", "1219", "12le"
#$testdata | select-string -Pattern "^d{4}$"
#Select-String "$regex" -InputObject "$testdata" | get-member
$match = @()
$LDAPFilter = ''

$LDAPFilter = '(&'
$LDAPFilter += '((Name>=0)(Name<=9))'    #Name must start with a number
#$LDAPFilter += '(^d{4}$)'    #Name must start with a number
$LDAPFilter += ')'
$match = Get-ADgroup -searchbase "OU=DLs,OU=Exchange,DC=corp,DC=gianteagle,DC=com" -LDAPFilter $LDAPFilter
$match = $match | where-object {$_.Name -notlike "*Faxes*" -or $_.Name -notlike "*RXM*" -or $_.Name -notlike "*FaxLine*"}
Write-host "found $($match.count) matches to filter: $ldapfilter"
$match | Export-Csv -path C:/temp/DLcleanup_221_2.csv
Write-host "C:/temp/DLcleanup.csv"

$match | Select-Object -first 400 | Export-Csv -path C:/temp/DLcleanup_Deleted_221_2.csv #who
$match | remove-adgroup #what
