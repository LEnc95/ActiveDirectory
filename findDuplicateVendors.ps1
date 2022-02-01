$upn += get-aduser -filter {UserPrincipalName -like "*2@*"} | Select-Object UserPrincipalName
$upn | ForEach-Object {
    $report += $_.UserPrincipalName.Split("2")[0] -replace '[^a-zA-Z-]'
}
$report