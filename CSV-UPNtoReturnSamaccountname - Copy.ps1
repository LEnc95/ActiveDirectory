Import-csv -Path "C:\Users\914476\Downloads\AllMFAUsers_2021-01-14.csv" | foreach {
    $user = $_
    Get-ADUser -Filter "UserPrincipalName -eq '$($user.{User Name})'"
} | Export-Csv -Path "C:\Users\914476\Documents\GitHub\Reports\AllMFAUsers.csv" -Force