$csvFile = 'C:\Users\914476\Documents\PRODRetailPricingApplicationAccessRequest_FullListofUsers.csv'
$parentDirectory = (Get-Item $csvFile).Directory.FullName
$csvData = Import-Csv -Path $csvFile
$results = foreach ($row in $csvData) {
    $email = $row.email
    $user = Get-ADUser -Filter "EmailAddress -eq '$email'" -Properties samaccountname
    $samaccountname = $user.samaccountname
    [PSCustomObject]@{
        Email = $email
        SamAccountName = $samaccountname
    }
}
$results | Format-Table -AutoSize 
$exportPath = "$parentDirectory\PRODRetailPricingApplicationAccessRequest_FullListofUsers_SamAccountNames.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Exported CSV file path: $exportPath"
