$users = Get-ADGroupMember SG_PDX_TurnRX_StoreUser | ForEach-Object {Get-ADUser $_.samaccountname -Properties UserPrincipalName, Department} | Select-Object samaccountname, UserPrincipalName, Department
$users | ForEach-Object {
    if($_.Department -ne ($_.UserPrincipalName -replace "\D")){
        Set-ADUser $_.samaccountname -Department "$($_.UserPrincipalName -replace "\D")"
    }
}