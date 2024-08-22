$missingEmployeeID = Get-ADUser -SearchBase "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com" -Properties employeeID -Filter {employeeID -notlike '*' -and SamAccountName -like '9*'}
$missingEmployeeID | export-csv -path "C:\Users\914476\Documents\GitHub\Reports\contractorsMissingEmployeeID.csv"

foreach($employee in $missingEmployeeID){
    $accountName = Get-ADUser -Identity $employee -Properties * | select SamAccountName
    $accountName.SamAccountName
    Set-ADUser -Identity $accountName.SamAccountName -EmployeeID $accountName.SamAccountName
    Write-host "$accountName employeeID was updated"
}