$DateTime = Get-Date -f "yyyy-MM-dd"
$group = Read-Host 'Paste the group name from AD ' #'DEPT_IS_SR_MGMT_PAGE'
$CSVFile = "$env:USERPROFILE\Documents\GitHub\Reports\"+$group+"_"+$DateTime+".csv" 

Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    Get-ADUser -Property msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName | Export-Csv -Path $CSVFile -NoTypeInformation | Out-String -Width 10000
Write-Host $group " has been exported to " $CSVFile