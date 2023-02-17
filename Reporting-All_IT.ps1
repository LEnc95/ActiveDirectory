$users = @()
$report = @()
$users += Get-ADGroupMember -Identity "DL_Corp_IT" | Select-Object SamAccountName 
$users += Get-ADGroupMember -Identity "DL_Corp_IT_Contractors" | Select-Object SamAccountName 
$users | ForEach-Object {
    $report += Get-ADUser $_.samaccountname -Properties employeetype | Select-Object GivenName, SurName, SamAccountName, employeetype
} 
$report | Export-Csv -Path C:\Temp\ALL_IT.csv -NoTypeInformation

