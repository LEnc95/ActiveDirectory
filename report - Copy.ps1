#Import-Module ActiveDirectory

#Required Variables
$group = 'DEPT_IS_SR_MGMT_PAGE'
$CSVFile = "$env:USERPROFILE\Documents\GitHub\"+$group+"_"+$DateTime+".csv" 

#Return SamAccountName of users in a group
#$user = Get-ADGroupMember -identity $group | select samaccountname | Export-csv -path $CSVFile -NoTypeInformation

# Will only work for groups with less than 5000 members
#Get-ADGroupMember -Identity "Digipass Users" |%{get-aduser $_.SamAccountName | select userPrincipalName } > $CSVFile

#Retun detailed user information for members of a group
Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    Get-ADUser -Property Name, DisplayName | Export-Csv -Path $CSVFile -NoTypeInformation | Out-String -Width 10000
<#  Create Hash table of users to lookup distinguished name.
$users = @{}
Get-ADUser -Filter '*' -Property Name, DisplayName | ForEach-Object {
    $users[$_.DistinguishedName] = $_
}

Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    ForEach-Object { $users[$_] }
#>