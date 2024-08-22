# Import the Active Directory module
Import-Module ActiveDirectory

# Set the OU path to "Retail Users FIM OU"
$ouPath = "OU=Retail Users FIM,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"

# Get all AD users in the specified OU path
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties DepartmentNumber

# Initialize a hashtable to store the counts
$departmentCounts = @{}

# Loop through each user and count the number of departments
foreach ($user in $users) {
    $departments = $user.DepartmentNumber
    $numDepartments = $departments.Count

    # Update the department count in the hashtable
    if ($departmentCounts.ContainsKey($numDepartments)) {
        $departmentCounts[$numDepartments]++
    } else {
        $departmentCounts[$numDepartments] = 1
    }
}

# Output the maximum number of departments
$maxDepartments = $departmentCounts.Keys | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
Write-Host "The maximum number of departments a user could have is: $maxDepartments"

# Output the count of users for each number of departments
Write-Host "Users count by number of departments:"
$departmentCounts.GetEnumerator() | Sort-Object Name | ForEach-Object {
    $numDepartments = $_.Key
    $userCount = $_.Value
    Write-Host "Number of departments: $numDepartments | Users count: $userCount"
}