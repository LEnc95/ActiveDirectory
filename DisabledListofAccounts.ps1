# Import the Active Directory module (if not already imported)
Import-Module ActiveDirectory

# Define the list of accounts to disable
$accounts = @(
    "GIANTEAGLE\svc_fim_ad",
    "GIANTEAGLE\svc_bhold_core",
    "GIANTEAGLE\svc_bhold_core_dev",
    "GIANTEAGLE\svc_fim_sqls",
    "GIANTEAGLE\svc_fim_adfs",
    "GIANTEAGLE\svc_fim_admin",
    "GIANTEAGLE\svc_fim_sqla",
    "GIANTEAGLE\svc_fim_sync",
    "GIANTEAGLE\svc_fim_batch",
    "GIANTEAGLE\sv_fim_pwd",
    "GIANTEAGLE\svc_fim_apppool",
    "GIANTEAGLE\svc_fim_adfs_dev"
)

# Loop through each account, disable it, and confirm the status
foreach ($account in $accounts) {
    $username = $account.Split('\')[1] # Extract just the username
    try {
        # Disable the account
        Disable-ADAccount -Identity $username -ErrorAction Stop
        Write-Host "Disabled user: $account"

        # Verify the account status
        $user = Get-ADUser -Identity $username -Properties Enabled
        if (-not $user.Enabled) {
            Write-Host "Confirmed: $account is disabled."
        } else {
            Write-Host "Error: $account is still enabled."
        }
    } catch {
        Write-Host "Failed to process $($account): $($_.Exception.Message)"
    }
}