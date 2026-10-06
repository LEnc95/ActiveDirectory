#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
    Captures and (optionally) disables all Verisae vendor ('vnd') AD accounts,
    domain-wide, regardless of OU.

.DESCRIPTION
    Two-phase, capture-first cleanup tool.

    Default run (no -Disable): READ-ONLY. Resolves every matching account across the
    entire domain, writes a full inventory to CSV, and stops. Nothing is changed.
    Review the CSV, confirm the match set is correct, then re-run with -Disable.

    -Disable run: Disables every *currently enabled* match (idempotent), appends a
    stamp to each account's 'info' attribute ("Disabled per <CHG> on <date>
    (verisae/vnd cleanup)") so the staged deletion change can target exactly this
    set, and logs every action via transcript. The pre-change CSV doubles as the
    backout source: its Enabled='True' rows are precisely the accounts this run
    turned off.

.PARAMETER Keyword
    Substring matched against sAMAccountName, Name, and Description. Default: 'verisae'.

.PARAMETER SamAccountNamePrefix
    Optional. If the vendor convention prefixes the logon name (e.g. 'vnd'), pass it
    here to widen the match to accounts that don't literally contain the keyword.

.PARAMETER ChangeNumber
    Change record this run executes under. Written to the 'info' stamp.
    Required for a real -Disable (not required for -Disable -WhatIf previews).

.PARAMETER Disable
    Perform the disable. Omit for a read-only capture.

.PARAMETER OutputPath
    Folder for the CSV + log. Default: current directory.

.EXAMPLE
    .\Disable-VerisaeAccounts.ps1
    Read-only capture. Produces the inventory CSV for review.

.EXAMPLE
    .\Disable-VerisaeAccounts.ps1 -Disable -WhatIf
    Dry run: shows exactly which accounts would be disabled.

.EXAMPLE
    .\Disable-VerisaeAccounts.ps1 -ChangeNumber CHG0012345 -Disable
    Executes the disable under the given change.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Keyword = 'verisae',
    [string]$SamAccountNamePrefix,
    [string]$ChangeNumber,
    [switch]$Disable,
    [string]$OutputPath = (Get-Location).Path
)

if ($Disable -and -not $WhatIfPreference -and -not $ChangeNumber) {
    throw "-ChangeNumber is required for a real -Disable (it is written to the audit stamp). " +
          "Use -Disable -WhatIf to preview without one."
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$mode      = if ($Disable) { 'disable' } else { 'capture' }
$csvPath   = Join-Path $OutputPath "verisae-accounts_${mode}_$timestamp.csv"
$logPath   = Join-Path $OutputPath "verisae-accounts_${mode}_$timestamp.log"

Start-Transcript -Path $logPath -Append | Out-Null
try {
    $searchBase = (Get-ADDomain).DistinguishedName    # domain root => every OU

    # --- Build match filter (edit here if your convention differs) ---
    $k = $Keyword.Replace('*', '')
    $clauses = @(
        "(sAMAccountName=*$k*)"
        "(name=*$k*)"
        "(description=*$k*)"
    )
    if ($SamAccountNamePrefix) {
        $p = $SamAccountNamePrefix.Replace('*', '')
        $clauses += "(sAMAccountName=$p*)"
    }
    $ldapFilter = "(&(objectCategory=person)(objectClass=user)(|$($clauses -join '')))"

    Write-Host "Mode        : $mode"
    Write-Host "Search base : $searchBase"
    Write-Host "LDAP filter : $ldapFilter"
    Write-Host ""

    $props = @(
        'SamAccountName','Name','DistinguishedName','Enabled','Description',
        'info','whenCreated','LastLogonDate','Company','Department'
    )

    $accounts = Get-ADUser -LDAPFilter $ldapFilter -SearchBase $searchBase `
                    -Properties $props -ResultSetSize $null |
                Select-Object $props

    if (-not $accounts) {
        Write-Warning "No accounts matched. Nothing to capture or disable."
        return
    }

    # Pre-change snapshot (also the backout source).
    $accounts | Sort-Object Enabled, SamAccountName |
        Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

    $total   = @($accounts).Count
    $enabled = @($accounts | Where-Object Enabled).Count
    Write-Host ("Matched {0} account(s): {1} enabled, {2} already disabled." -f `
        $total, $enabled, ($total - $enabled))
    Write-Host "Inventory   : $csvPath"

    if (-not $Disable) {
        Write-Host ""
        Write-Host "READ-ONLY capture complete. Review the CSV, then re-run with -ChangeNumber <CHG> -Disable."
        return
    }

    # ----- Disable phase -----
    $stamp   = "Disabled per $ChangeNumber on $(Get-Date -Format 'yyyy-MM-dd') (verisae/vnd cleanup)"
    $targets = $accounts | Where-Object Enabled
    $ok = 0; $failed = 0

    foreach ($a in $targets) {
        if ($PSCmdlet.ShouldProcess($a.DistinguishedName, "Disable account + stamp info")) {
            try {
                Disable-ADAccount -Identity $a.DistinguishedName -ErrorAction Stop
                $note = if ($a.info) { "$($a.info) | $stamp" } else { $stamp }
                Set-ADUser -Identity $a.DistinguishedName -Replace @{ info = $note } -ErrorAction Stop
                $ok++
                Write-Host "  disabled  $($a.SamAccountName)"
            }
            catch {
                $failed++
                Write-Warning "  FAILED    $($a.SamAccountName): $($_.Exception.Message)"
            }
        }
    }

    Write-Host ""
    Write-Host ("Disable complete under {0}: {1} disabled, {2} failed, {3} already disabled (skipped)." -f `
        $ChangeNumber, $ok, $failed, ($total - $enabled))
    Write-Host "Backout src : $csvPath   (re-enable rows where Enabled='True')"
    Write-Host "Log         : $logPath"
}
finally {
    Stop-Transcript | Out-Null
}