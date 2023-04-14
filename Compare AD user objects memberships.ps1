# Set the list of user objects to audit
$users = "AAprodRunner1", "AAprodRunner2", "AAprodRunner3", "AAprodRunner4", "AAprodRunner5", "AAprodRunner6", "AAprodRunner7", "AAprodRunner8", "AAprodRunner9", "AAprodRunner10"

# Loop through each user and compare their group membership
foreach ($user in $users) {
    # Get the group membership of the current user
    $currentGroups = (Get-ADUser $user -Properties memberof).memberof

    # Compare the group membership of the current user with the first user in the list
    if ($user -eq $users[0]) {
        $compareGroups = $currentGroups
    } else {
        $compareGroups = (Compare-Object $compareGroups $currentGroups).InputObject
    }

    # Print the group membership differences
    Write-Output "Group membership differences for user "+$user+":"
    foreach ($group in $compareGroups) {
        if ($currentGroups -notcontains $group) {
            Write-Output "Removed from group: $group"
        } elseif ($compareGroups -notcontains $group) {
            Write-Output "Added to group: $group"
        }
    }
}
