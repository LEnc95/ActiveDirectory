$users = import-csv -Path C:\Users\914476\Documents\GitHub\_infile\briansUsers.csv
$employeeid = $users.{Team Member ID}
foreach($user in $users){
        get-aduser -filter {EmployeeID -eq $employeeid}
}