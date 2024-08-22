# Define the target OU
$ouPath = "OU=Admin Accounts,OU=RBAC,DC=corp,DC=gianteagle,DC=com"

# Calculate the date 90 days ago
$90DaysAgo = (Get-Date).AddDays(-90)
$365DaysAgo = (Get-Date).AddDays(-365)

# Get the accounts in the specified OU
$accounts = Get-ADUser -Filter * -SearchBase $ouPath -Properties LastLogonDate, WhenCreated

# Loop through the accounts
foreach ($account in $accounts) {
    # Check if last logon date is within the last 365 days
    $lastLogon = $account.LastLogonDate
    $whenCreated = $account.WhenCreated
    if ($whenCreated -lt $365DaysAgo){
        if ($lastLogon -eq $null -or ($lastLogon -ne $null -and $lastLogon -lt $365DaysAgo)) {
            # Set the account expiration date to disable the account
            $expirationDate = (Get-Date).AddDays(1) # Expiring the account today
            
            # Calculate the number of days since last logon if last logon is not null
            if ($lastLogon -ne $null) {
                $daysSinceLastLogon = (Get-Date).Subtract($lastLogon.Date).Days
            } else {
                $daysSinceLastLogon = "N/A"
                $lastLogon = "never"
            }
            
            Set-ADUser -Identity $account.DistinguishedName -AccountExpirationDate $expirationDate
    
            Write-Host "Account $($account.SamAccountName) expired due to inactivity. Object provisioned $($account.WhenCreated) and last signed in $($daysSinceLastLogon) days ago at $($lastLogon)."
        }
    }
}
