#$users = Get-Content -Path ""
$users = "914476", "1015397"
$filter = @()
$users | ForEach-Object {
    $filter += Get-aduser -Identity $_ -Properties Department, extensionAttribute13 | Select-Object Department, extensionAttribute13
}
$filter