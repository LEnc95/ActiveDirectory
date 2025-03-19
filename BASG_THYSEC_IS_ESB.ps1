$UPNs = @(
    "Prasanth.SaiKumar@gianteagle.com",
    "Mahesh.Nanjarapalli@gianteagle.com",
    "Prasanna.Kulkarni@gianteagle.com",
    "Venkata.Harish@gianteagle.com",
    "Kumar.Reddy@gianteagle.com",
    "Kriti.Srivastava@gianteagle.com"
)

#get users samaccountname from UPN and save to users array
$users = @()
foreach ($UPN in $UPNs) {
    $user = Get-ADUser -Filter { UserPrincipalName -eq $UPN } -Properties SamAccountName
    $users += $user
}

#add users to BASG_THYSEC_IS_ESB group if they are not already a member of the group 
foreach ($user in $users) {
    $group = "BASG_THYSEC_IS_ESB"
    $isMember = Get-ADGroupMember -Identity $group | Where-Object { $_.SamAccountName -eq $user.SamAccountName }

    if ($isMember) {
        Write-Host "$($user.SamAccountName) is already a member of $group."
    } else {
        Add-ADGroupMember -Identity $group -Members $user.SamAccountName
        Write-Host "$($user.SamAccountName) added to $group."
    }
}