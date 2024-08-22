Import-Module ActiveDirectory
while($true){
$accountName = Read-Host "Employee ID Number"
$createdDate = Get-ADUser -Identity $accountName -Properties * | select whenCreated
Write-Host $createdDate
}
