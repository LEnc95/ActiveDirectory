# Set the AD group name
$groupName = "MIM_Expired_Vendor"

# Get the AD group members
$groupMembers = Get-ADGroupMember -Identity $groupName

# Disable enabled members of the group
foreach ($member in $groupMembers) {
    $user = Get-ADUser -Identity $member.SamAccountName
    if ($user.Enabled -eq $true) {
        Disable-ADAccount -Identity $user.SamAccountName
    }
}
