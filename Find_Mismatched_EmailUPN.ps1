<#$users = (
    "1140219",
    "1314474",
    "1316314",
    "1110252",
    #"1007683", Bad ID provided
    "1007638",
    "2025022",
    "1050514"
)
$users | ForEach-Object {
    Get-aduser $_ -Properties EmailAddress, UserPrincipalName, employeeid | Select-Object EmailAddress, UserPrincipalName, samaccountname, employeeid
}#>
$mismatched = ""
$users = Get-aduser -Filter * -Properties EmailAddress <#| Select-Object -First 100#>
$mismatched = $users | Select-Object <#-First 100#> EmailAddress, UserPrincipalName | Where-Object {$_.UserPrincipalName -NE $_.EmailAddress -and $_.EmailAddress -NE $NULL}
$mismatched | Export-Csv -Path C:\Temp\mismatchedUPN.csv