# Import the Active Directory module
Import-Module ActiveDirectory

# Set the OU path to "Retail Users FIM OU"
$ouPath = "OU=Retail Users FIM,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"

# Get all AD users in the specified OU path
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties DepartmentNumber 

# Initialize a variable to store the maximum number of departments
$maxDepartments = 0

# Loop through each user and count the number of departments
foreach ($user in $users) {
    $departments = $user.DepartmentNumber
    $numDepartments = $departments.Count

    # Update the maximum number of departments if necessary
    if ($numDepartments -gt $maxDepartments) {
        $maxDepartments = $numDepartments
    }
}

# Output the maximum number of departments
Write-Host "The maximum number of departments a user could have is: $maxDepartments"
