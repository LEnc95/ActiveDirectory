# Import the necessary modules
#Import-Module ActiveDirectory

# Specify the path to the exported CSV file
$csvPath = "C:\Users\914476\OneDrive - Giant Eagle, Inc\service accounts.csv"

# Read the CSV file
$accounts = Import-Csv $csvPath

# Create an array to store the results
$results = @()

# Iterate through the accounts and look them up in Active Directory
foreach ($account in $accounts) {
    $accountName = $account.AccountName
    $accountOwner = $account.Manager

    # Check if the account exists in Active Directory
    if (Get-ADUser -Filter {SamAccountName -eq $accountName} -ErrorAction SilentlyContinue) {
        # Get the account details
        $user = Get-ADUser $accountName -Properties DistinguishedName, managedby

        # Add the account details to the results array
        $result = [PSCustomObject] @{
            AccountName = $accountName
            OUPath = $user.DistinguishedName
            UPN = $user.UserPrincipalName
            AD_Manager = $user.managedby
            SN_Owner = $accountOwner
        }
        $results += $result
    }
}

# Display the results
$results | Format-Table -AutoSize
