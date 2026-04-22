param(
    [string]$OuSearchFilter = 'Name -like "*RBAC*"',
    [string]$OuDistinguishedName = 'OU=Manual,OU=RBAC,DC=corp,DC=gianteagle,DC=com',
    [string]$Server = 'corp.gianteagle.com'
)

Import-Module ActiveDirectory -ErrorAction Stop

$groupName = "SG_ENT_AI_COP"
$groupDescription = "Users to who would like access related to AI COP Usage."
$userIdentifiers = @(
    "2056344",
    "2131077"
)

# Optional -Server splat for AD cmdlets
$adServerSplat = @{}
if ($Server) { $adServerSplat.Server = $Server }

# Resolve target OU for RBAC path if provided/found
$targetOuDn = $null
if ($OuDistinguishedName) {
    $targetOuDn = $OuDistinguishedName
} else {
    try {
        $ous = Get-ADOrganizationalUnit @adServerSplat -Filter $OuSearchFilter -ErrorAction SilentlyContinue
        $ouArray = @($ous)
        if ($ouArray.Count -eq 1) {
            $targetOuDn = $ouArray[0].DistinguishedName
            Write-Host "Using RBAC OU: $targetOuDn" -ForegroundColor Cyan
        } elseif ($ouArray.Count -gt 1) {
            Write-Host "Multiple candidate RBAC OUs found. Specify -OuDistinguishedName to select one:" -ForegroundColor Yellow
            $ouArray | Select-Object Name, DistinguishedName | ForEach-Object { Write-Host " - $($_.Name): $($_.DistinguishedName)" }
        } else {
            Write-Host "No RBAC OU matched filter: $OuSearchFilter" -ForegroundColor Yellow
        }
    } catch {
        Write-Warning "Failed to search for RBAC OU: $($_.Exception.Message)"
    }
}

function Resolve-AdUserByIdentifier {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Identifier
    )

    # Try employeeID first
    $user = Get-ADUser @adServerSplat -Filter "employeeID -eq '$Identifier'" -ErrorAction SilentlyContinue

    if (-not $user) {
        # Fallback to sAMAccountName
        $user = Get-ADUser @adServerSplat -Filter "sAMAccountName -eq '$Identifier'" -ErrorAction SilentlyContinue
    }

    if (-not $user) {
        Write-Warning "Unable to resolve user for identifier: $Identifier"
    }

    return $user
}

try {
    $existingGroup = Get-ADGroup @adServerSplat -Filter "sAMAccountName -eq '$groupName'" -ErrorAction SilentlyContinue

    if (-not $existingGroup) {
        Write-Host "Creating group: $groupName" -ForegroundColor Cyan
        if ($targetOuDn) {
            New-ADGroup @adServerSplat -Name $groupName -SamAccountName $groupName -GroupScope Global -GroupCategory Security -Description $groupDescription -Path $targetOuDn -ErrorAction Stop | Out-Null
        } else {
            New-ADGroup @adServerSplat -Name $groupName -SamAccountName $groupName -GroupScope Global -GroupCategory Security -Description $groupDescription -ErrorAction Stop | Out-Null
        }
        $existingGroup = Get-ADGroup @adServerSplat -Identity $groupName -ErrorAction Stop
    } else {
        Write-Host "Group already exists: $groupName" -ForegroundColor Yellow
        # Ensure description is set/updated
        $currentDescription = (Get-ADGroup @adServerSplat -Identity $existingGroup.DistinguishedName -Properties Description).Description
        if ($currentDescription -ne $groupDescription) {
            Write-Host "Updating group description" -ForegroundColor Cyan
            Set-ADGroup @adServerSplat -Identity $existingGroup.DistinguishedName -Description $groupDescription -ErrorAction Stop
        }
    }

    $resolvedUsers = @()
    foreach ($id in $userIdentifiers) {
        $user = Resolve-AdUserByIdentifier -Identifier $id
        if ($user) { $resolvedUsers += $user }
    }

    if ($resolvedUsers.Count -gt 0) {
        foreach ($user in $resolvedUsers) {
            try {
                # Add idempotently; ignore if already a member
                Add-ADGroupMember @adServerSplat -Identity $existingGroup.DistinguishedName -Members $user.DistinguishedName -ErrorAction Stop
                Write-Host "Added member: $($user.SamAccountName)" -ForegroundColor Green
            } catch {
                if ($_.Exception.Message -match "is already a member of") {
                    Write-Host "Already a member: $($user.SamAccountName)" -ForegroundColor Yellow
                } else {
                    throw
                }
            }
        }
    } else {
        Write-Warning "No users were resolved from the provided identifiers."
    }

    Write-Host "Completed group setup for $groupName" -ForegroundColor Green
} catch {
    Write-Error $_
    exit 1
}
