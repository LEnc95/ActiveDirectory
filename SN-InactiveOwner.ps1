#get all AD groups that start with SN_ and return the ManagedBy attribute
$groups = Get-ADGroup -Filter 'Name -like "SN_*"' -Properties ManagedBy | Select-Object Name, ManagedBy
$result = @()

#for each group check if the ManagedBy attribute is empty
foreach ($group in $groups) {
    if ($group.ManagedBy -eq $null) {
        #if the ManagedBy attribute is empty, output the group name has no owner
        Write-Host "$($group.Name) has no owner"
        $result += [PSCustomObject]@{
            GroupName = $group.Name
            Owner = "No owner"
        }
    }
    #if the managedBy attribute is not empty check if the group owner is disabled
    else {
        $owner = Get-ADUser -Identity $group.ManagedBy
        if ($owner.Enabled -eq $false) {
            #if the group owner is disabled, output the group name and owner
            Write-Host "$($group.Name) is owned by $($owner.GivenName) $($owner.Surname) ($($owner.SamAccountName)) who is disabled"
            $result += [PSCustomObject]@{
                GroupName = $group.Name
                Owner = "$($owner.GivenName) $($owner.Surname) ($($owner.SamAccountName)) (Disabled)"
            }
        }
    }
}

# Export the report to a CSV file in the temp directory
$result | Export-Csv -Path "C:\temp\ADGroupReport.csv" -NoTypeInformation
