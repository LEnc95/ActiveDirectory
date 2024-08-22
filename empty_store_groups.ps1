# Import the Active Directory module
Import-Module ActiveDirectory

# Initialize the results array
$results = @()

    $groups = Get-ADGroup -Filter { Name -like "MIM_FC*" -or Name -like "MIM_GC*" -and GroupCategory -eq 'Security' }

    foreach ($group in $groups) {
        # Count the number of members in the current group
        $memberCount = (Get-ADGroupMember -Identity $group).Count

        # Add the group and its member count to the results
        $results += [PSCustomObject]@{
            'GroupName' = $group.Name
            'MemberCount' = $memberCount
        }
    }

# Display the results
$results | Format-Table -AutoSize

