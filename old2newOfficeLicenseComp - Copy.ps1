Import-Module ActiveDirectory
#get-adgroupmember -Identity "O365.Standard"
$group = "O365.Standard"
<#Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    Get-ADUser -Property Name, DisplayName#>

$users = @{}
Get-ADUser -Filter '*' -Property Name, DisplayName | ForEach-Object {
    $users[$_.DistinguishedName] = $_
}
Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    ForEach-Object { $users[$_] }