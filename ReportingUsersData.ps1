$users = @(
    "1000935@gianteagle.com",
    "1003034@gianteagle.com",
    "1097654@gianteagle.com",
    "1161641@gianteagle.com",
    "1174374@gianteagle.com",
    "1000837@gianteagle.com",
    "margaret.allison@gianteagle.com",
    "john.adams@gianteagle.com",
    "tim.baker@gianteagle.com",
    "lisa.clark@gianteagle.com",
    "paul.davis@gianteagle.com",
    "sarah.evans@gianteagle.com",
    "nancy.foster@gianteagle.com",
    "luis.gomez@gianteagle.com",
    "julie.harris@gianteagle.com",
    "keith.irwin@gianteagle.com",
    "laura.jackson@gianteagle.com",
    "robert.kelly@gianteagle.com",
    "ana.lopez@gianteagle.com",
    "sophia.martinez@gianteagle.com",
    "charles.nelson@gianteagle.com",
    "maria.owens@gianteagle.com",
    "david.perez@gianteagle.com",
    "emma.quinn@gianteagle.com",
    "brian.reed@gianteagle.com",
    "olivia.smith@gianteagle.com",
    "daniel.taylor@gianteagle.com",
    "zoe.underwood@gianteagle.com",
    "eric.vargas@gianteagle.com",
    "helen.white@gianteagle.com",
    "mark.young@gianteagle.com",
    "chloe.zimmer@gianteagle.com"
)

# report users AD data
$results = foreach ($user in $users) {
    $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$user'" -Properties samaccountname, emailaddress, Title, Department, employeeType, whenChanged, whenCreated
    $samaccountname = $adUser.samaccountname
    $email = $adUser.emailaddress
    $title = $adUser.Title
    $department = $adUser.Department
    $employeeType = $adUser.employeeType
    $whenChanged = $adUser.whenChanged
    $whenCreated = $adUser.whenCreated
    [PSCustomObject]@{
        UserPrincipalName = $user
        SamAccountName = $samaccountname
        Email = $email
        Title = $title
        Department = $department
        EmployeeType = $employeeType
        WhenChanged = $whenChanged
        WhenCreated = $whenCreated
    }
}

foreach ($user in $users) {
    Set-ADUser -Identity $user -PasswordNeverExpires $false
}

foreach ($user in $users) {
    $user = Get-AzureADUser -ObjectId $user
    Set-AzureADUser -ObjectId $user.ObjectId -PasswordPolicies "None"
}

# export report to CSV
$exportPath = "C:\temp\UsersPassPol.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Exported CSV file path: $exportPath"