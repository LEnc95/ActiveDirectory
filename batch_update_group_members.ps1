# Define the group name
$GroupName = "SG_OneTrust_SysAdmin"

# Define the new members using their SamAccountNames
$NewMembersSamAccountNames = @('1228669', '1018219', '2002612', '2024929', '2103900', '2048072') # Replace with actual SamAccountNames

# Get all current group members
$CurrentMembers = Get-ADGroupMember -Identity $GroupName | Get-ADUser -Properties SamAccountName

# Remove users who are not in the new members list
foreach ($Member in $CurrentMembers) {
    if ($NewMembersSamAccountNames -notcontains $Member.SamAccountName) {
        Remove-ADGroupMember -Identity $GroupName -Members $Member -Confirm:$false -ErrorAction SilentlyContinue
    }
}

# Add new members to the group
foreach ($SamAccountName in $NewMembersSamAccountNames) {
    # Check if the user is already a member of the group
    $isMember = $CurrentMembers.SamAccountName -contains $SamAccountName
    
    # If the user is not already a member, add them to the group
    if (-not $isMember) {
        try {
            Add-ADGroupMember -Identity $GroupName -Members $SamAccountName -ErrorAction Stop
        } catch {
            Write-Warning "Could not add user $($SamAccountName) to the group $GroupName: $_"
        }
    }
}

# Output completion message
Write-Host "Group membership for $GroupName has been updated."
