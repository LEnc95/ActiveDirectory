function peaches {
    
Get-ADGroup -Filter "Name -like 'svc_*'" | ForEach {

    $groupName = $_.Name

    Get-ADGroupMember -Identity $_.SamAccountName | 
        Select @{N='GroupName';E={$groupName}},SamAccountName,Name

}
}


Get-ADUser -Filter * | Where-Object { $_.DisplayName -like "svc_mim_admin" } | Select-Object -Property SamAccountName