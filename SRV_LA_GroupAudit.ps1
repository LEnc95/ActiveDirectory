<#        
    .SYNOPSIS 
    Audit SRV_*_LA group memberships - report only, no changes made.

    .DESCRIPTION
    Finds all AD groups matching SRV_*_LA. For each group, identifies direct
    user members whose samAccountName does NOT end in PA02 (primary accounts).
    For each primary account, checks whether a corresponding PA02 account exists
    (samAccountName + "PA02") and whether that PA02 is already a member of the
    same group. Reports what WOULD be changed to replace primary accounts with
    their PA02 equivalents. No AD modifications are made.

    .NOTES
    ========================================================================
         Windows PowerShell Source File

         NAME: SRV_LA_GroupAudit.ps1

         AUTHOR: Encrapera, Luke
         DATE  : 05/05/2026

         COMMENT: Report-only. No Add-ADGroupMember or Remove-ADGroupMember calls.

    ==========================================================================
#>

$DateTime  = Get-Date -f "yyyy-MM-dd_HHmmss"
$OutputCSV = "c:\temp\SRV_LA_Audit_$DateTime.csv"

Write-Host "Querying AD for groups matching SRV_*_LA..." -ForegroundColor Cyan

$Groups = Get-ADGroup -Filter "Name -like 'SRV_*_LA'" -Properties Name, DistinguishedName -Server "corp.gianteagle.com" |
          Sort-Object Name

if (-not $Groups) {
    Write-Host "No groups found matching SRV_*_LA. Exiting." -ForegroundColor Yellow
    return
}

Write-Host "Found $($Groups.Count) group(s). Processing members..." -ForegroundColor Cyan

$Results = [System.Collections.Generic.List[PSCustomObject]]::new()

$i = 0
foreach ($Group in $Groups) {
    $i++
    $pct = [math]::Round(($i / $Groups.Count) * 100)
    Write-Progress -Activity "Auditing SRV_*_LA Groups" `
                   -Status "[$i of $($Groups.Count)] $($Group.Name)" `
                   -PercentComplete $pct

    # Get all direct user members of the group
    $AllMembers = Get-ADGroupMember -Identity $Group.DistinguishedName -Server "corp.gianteagle.com" |
                  Where-Object { $_.objectClass -eq 'user' }

    # Separate primary (non-PA02) accounts from PA02 accounts already in group
    $PrimaryMembers  = $AllMembers | Where-Object { $_.SamAccountName -notlike '*PA02' }
    $PA02MembersInGrp = $AllMembers | Where-Object { $_.SamAccountName -like '*PA02' } |
                        Select-Object -ExpandProperty SamAccountName

    foreach ($Member in $PrimaryMembers) {
        # Get primary account details
        $PrimaryUser = Get-ADUser -Identity $Member.SamAccountName `
                                  -Properties DisplayName, Enabled `
                                  -Server "corp.gianteagle.com" -ErrorAction SilentlyContinue

        $DisplayName          = if ($PrimaryUser) { $PrimaryUser.DisplayName } else { "N/A" }
        $PrimaryAccountEnabled = if ($PrimaryUser) { $PrimaryUser.Enabled }    else { "N/A" }

        # Construct and look up the PA02 account
        $PA02Sam  = $Member.SamAccountName + "PA02"
        $PA02User = Get-ADUser -Filter "SamAccountName -eq '$PA02Sam'" `
                               -Properties Enabled `
                               -Server "corp.gianteagle.com" -ErrorAction SilentlyContinue

        $PA02Exists  = if ($PA02User)  { $true }  else { $false }
        $PA02Enabled = if ($PA02User)  { $PA02User.Enabled } else { "N/A" }

        # Check if PA02 is already a member of this group
        $PA02AlreadyMember = if ($PA02MembersInGrp -contains $PA02Sam) { $true } else { $false }

        # Determine proposed action
        $ProposedAction = if (-not $PA02Exists) {
            "No PA02 found - no action possible"
        } elseif ($PA02AlreadyMember) {
            "Remove $($Member.SamAccountName) (PA02 already member)"
        } else {
            "Remove $($Member.SamAccountName), Add $PA02Sam"
        }

        $Results.Add([PSCustomObject]@{
            GroupName              = $Group.Name
            PrimaryAccount         = $Member.SamAccountName
            DisplayName            = $DisplayName
            PrimaryAccountEnabled  = $PrimaryAccountEnabled
            PA02Account            = $PA02Sam
            PA02Exists             = $PA02Exists
            PA02Enabled            = $PA02Enabled
            PA02AlreadyMember      = $PA02AlreadyMember
            ProposedAction         = $ProposedAction
        })
    }
}

Write-Progress -Activity "Auditing SRV_*_LA Groups" -Completed

if ($Results.Count -eq 0) {
    Write-Host "No primary account members found in any SRV_*_LA group." -ForegroundColor Yellow
} else {
    $Results | Export-Csv -Path $OutputCSV -NoTypeInformation
    Write-Host ""
    Write-Host "Audit complete. $($Results.Count) row(s) exported to:" -ForegroundColor Green
    Write-Host $OutputCSV -ForegroundColor White

    # Summary breakdown
    $actionable    = $Results | Where-Object { $_.PA02Exists -eq $true }
    $noPA02        = $Results | Where-Object { $_.PA02Exists -eq $false }
    $alreadyMember = $Results | Where-Object { $_.PA02AlreadyMember -eq $true }

    Write-Host ""
    Write-Host "--- Summary ---" -ForegroundColor Cyan
    Write-Host "  Total primary account members found : $($Results.Count)"
    Write-Host "  PA02 exists (actionable)            : $($actionable.Count)"
    Write-Host "    - PA02 already in group           : $($alreadyMember.Count)"
    Write-Host "  No PA02 found (no action possible)  : $($noPA02.Count)"
}
