# List of users to add
$users = @()
$users += get-aduser -filter {name -like "aaprodrunner*"} | Select-Object samaccountname

# List of security groups to add users to
#Get-ADUser -Identity AAProdRunner1 -Properties memberof | Select-Object -ExpandProperty memberof
$groups = @("Office 365 Complete - Service Accounts - RPA", "Oracle Cloud ERP Users - Manual", "AAProdRunner", "SRV_RPABOT11APP4_LA", "SRV_RPABOT11APP3_LA", "SRV_RPABOT11APP2_LA", "SRV_RPABOT11APP1_LA", "Spaceman", "Spaceman Users", "App-Spaceman", "SG_RPA_Support")

Foreach($user in $users) {
    foreach($group in $groups) {
        Add-ADGroupMember -Identity $group -Members $user
    }
}










