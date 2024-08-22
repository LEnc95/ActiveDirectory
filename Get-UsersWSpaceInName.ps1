Import-Module ActiveDirectory

# Get AD user accounts with a space character in the last name
$users = Get-ADUser -Filter {Surname -like "* *"}

# Display the user accounts
foreach ($user in $users) {
    Write-Output "Username: $($user.SamAccountName)"
    Write-Output "Last Name: $($user.Surname)"
    Write-Output "First Name: $($user.GivenName)"
    Write-Output "------------------------"
}