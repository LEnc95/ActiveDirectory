$users | Get-Content -Path ""
$users | ForEach-Object {
    Set-ADAccountExpiration -Identity $_ -DateTime "11/02/2022"
}
