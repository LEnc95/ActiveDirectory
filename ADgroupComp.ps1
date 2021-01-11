
$group1 = "Password_Reset_MFA_Users"
$group2 = "PasswordReset.MFA"

$users = @{}
Get-ADUser  -Filter '*' -Property Name, DisplayName | Where {$_.Enabled -eq $True} | ForEach-Object {
    $users[$_.DistinguishedName] = $_
}

diff (
    Get-ADGroup $group1  -Properties Member |
    Select-Object -Expand Member |
    ForEach-Object { $users[$_] }
    )(
    Get-ADGroup $group2 -Properties Member |
    Select-Object -Expand Member |
    ForEach-Object { $users[$_] }
    ) -Property 'SamAccountName' -IncludeEqual | Export-Csv -Path .\Documents\GitHub\Reports\$group1'-'$group2.csv

#diff (Get-ADGroupMember $group1) (Get-ADGroupMember $group2) -Property 'SamAccountName' -IncludeEqual | Export-Csv -Path .\Documents\GitHub\Reports\$group1'-'$group2.csv
<#
$group1 = "Password_Reset_MFA_Users"
$group2 = "PasswordReset.MFA"
$users = @{}
Get-ADUser -Filter '*' -Property Name, DisplayName | ForEach-Object {$users[$_.DistinguishedName] = $_}
diff (Get-ADGroup $group1 -Properties Member | Select-Object -Expand Member | ForEach-Object { $users[$_] })(Get-ADGroup $group2 -Properties Member | Select-Object -Expand Member | ForEach-Object { $users[$_] }) -Property 'SamAccountName' -IncludeEqual | Export-Csv -Path .\Documents\GitHub\Reports\$group1'-'$group2.csv
#>

#Get-ADUser -LdapFilter "(&(!useraccountcontrol:1.2.840.113556.1.4.803:=2)(memberof=$(Get-ADGroup "Help Desk")))" | 
#	Select-Object Name,SamAccountName |Sort-Object samaccountname