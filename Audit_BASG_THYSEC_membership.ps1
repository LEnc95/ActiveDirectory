# Array of UPNs to audit
$UPNs = @(
    "Prasanth.SaiKumar@gianteagle.com",
    "Mahesh.Nanjarapalli@gianteagle.com",
    "Prasanna.Kulkarni@gianteagle.com",
    "Venkata.Harish@gianteagle.com",
    "Kumar.Reddy@gianteagle.com",
    "Kriti.Srivastava@gianteagle.com",
    "venkata.pothuri@gianteagle.com"
)

# Function to get the basg_thysec groups for a user
function Get-BasgThysecGroups {
    param (
        [string]$UPN
    )

    # Get the user by UPN
    $user = Get-ADUser -Filter { UserPrincipalName -eq $UPN } -Properties MemberOf

    if ($user) {
        # Retrieve all groups the user is a member of
        $groups = $user.MemberOf | ForEach-Object { Get-ADGroup -Identity $_ }

        # Filter the groups that contain 'basg_thysec' in the name
        $basgThysecGroups = $groups | Where-Object { $_.Name -like "*basg_thysec*" }

        # Return the basg_thysec group names
        return $basgThysecGroups.Name
    } else {
        return "User not found"
    }
}

# Loop through each UPN and get their basg_thysec groups
foreach ($UPN in $UPNs) {
    Write-Host "UPN: $UPN"

    $basgThysecGroups = Get-BasgThysecGroups -UPN $UPN

    if ($basgThysecGroups) {
        Write-Host "basg_thysec Groups:"
        $basgThysecGroups | ForEach-Object { Write-Host "- $_" }
    } else {
        Write-Host "No basg_thysec groups found."
    }

    Write-Host ""
}
# Loop through each UPN and check if they are members of BASG_THYSEC_IS_ESB
foreach ($UPN in $UPNs) {
    Write-Host "UPN: $UPN"

    $basgThysecGroups = Get-BasgThysecGroups -UPN $UPN

    if ($basgThysecGroups -contains "BASG_THYSEC_IS_ESB") {
        Write-Host "User is already a member of BASG_THYSEC_IS_ESB."
    } else {
        # Add the user to BASG_THYSEC_IS_ESB group
        try {
            Add-ADGroupMember -Identity "BASG_THYSEC_IS_ESB" -Members $UPN
            Write-Host "User added to BASG_THYSEC_IS_ESB group."
        } catch {
            Write-Host "Failed to add user to BASG_THYSEC_IS_ESB group: $_"
        }
    }

    Write-Host ""
if ($basgThysecGroups -notcontains "BASG_THYSEC_IS_ESB") {
    try {
        Add-ADGroupMember -Identity "BASG_THYSEC_IS_ESB" -Members $UPN.Split("@")[0]
        Write-Host "User added to BASG_THYSEC_IS_ESB group."
    } catch {
        Write-Host "Failed to add user to BASG_THYSEC_IS_ESB group: $_"
    }
}