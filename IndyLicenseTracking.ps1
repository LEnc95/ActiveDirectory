#$groupNames = 'O365.Basic','O365.Standard','O365.Complete','O365.Executive','SG_All365_Users_K1','SG_All365_Users_F1Base','SG_All365_Users_F1','SG_All365_Users_E3','SG_All365_Users_E5'

<#$users = @{}
Get-ADUser -Filter '*' -Property Name, DisplayName | ForEach-Object {
    $users[$_.DistinguishedName] = $_
}#>

#foreach ($group in $groupNames) {
#    Get-ADGroupMember -Identity $group | Where {$_.EmployeeType -eq "Independant"} | Select EmployeeID, DisplayName, Title, extensionAttribute13, Department
#     Get-ADGroup $group -Properties Member | Select-Object -Expand Member <#|  Where {$_.EmployeeType -eq "Independant"} #> | Select EmployeeID, DisplayName, Title, extensionAttribute13, Department, UserPrincipalName
#}
#>

<#
foreach ($group in $groupNames) {
    Get-ADGroup $group -Properties Member | Select-Object -ExpandProperty Member 
}#>

#// Start of script 
#// Get year and month for csv export file 
#$DateTime = Get-Date -f "yyyy-MM" 
 
#// Set CSV file name 
#$CSVFile = "$env:USERPROFILE\Documents\GitHub\"+$GroupName+"_"+$DateTime+".csv" 

#$groupNames = <#'O365.Basic','O365.Standard',#>'O365.Complete'#,'O365.Executive','SG_All365_Users_K1','SG_All365_Users_F1Base','SG_All365_Users_F1','SG_All365_Users_E3','SG_All365_Users_E5'

# -Filter {EmployeeType -eq "Independant"}
# Select-Object -Property @{Name = 'Name'; Expression = {$group.Name}}

#(Get-ADGroup -Identity  "O365.Executive" -properties members).members | Get-ADUser -properties * | 
#Select-Object EmployeeID, DisplayName, Title, extensionAttribute13, Department, UserPrincipalName #| Export-CSV ".\USERS005.csv" -noType


$groupNames = 'O365.Basic','O365.BasicPlus','O365.Standard','O365.Complete','O365.Executive','SG_All365_Users_K1','SG_All365_Users_F1Base','SG_All365_F1Base_EmailEnabled','SG_All365_Users_F1','SG_All365_Users_E3','SG_All365_Users_E5'

$output = foreach($group in $groupNames)
{
 $members = (Get-ADGroup -Identity  $group -properties members).members
 foreach($member in $members)
 {
    #Where {$_.EmployeeType -eq "Independent"}
    #where {$_.Department -eq "0389" -or $_.Department -eq "0600" -or $_.Department -eq "0605" -or $_.Department -eq "0607" -or $_.Department -eq "0614" -or $_.Department -eq "0617" -or $_.Department -eq "0619" -or $_.Department -eq "0621" -or $_.Department -eq "0625" -or $_.Department -eq "0626" -or $_.Department -eq "0632" -or $_.Department -eq "0641" -or $_.Department -eq "0643" -or $_.Department -eq "0645" -or $_.Department -eq "0646" -or $_.Department -eq "0660" -or $_.Department -eq "0664" -or $_.Department -eq "0665" -or $_.Department -eq "0667" -or $_.Department -eq "0670" -or $_.Department -eq "0673" -or $_.Department -eq "0678" -or $_.Department -eq "0682" -or $_.Department -eq "0683" -or $_.Department -eq "0687" -or $_.Department -eq "0688" -or $_.Department -eq "0695" -or $_.Department -eq "0698" -or $_.Department -eq "0699" -or $_.Department -eq "1041" -or $_.Department -eq "1219" -or $_.Department -eq "1602" -or $_.Department -eq "1603" -or $_.Department -eq "1608" -or $_.Department -eq "1609" -or $_.Department -eq "1670" -or $_.Department -eq "1691" -or $_.Department -eq "5844" -or $_.Department -eq "6384"}
    Get-ADUser $member -properties * | where {$_.Department -eq "0389" -or $_.Department -eq "0600" -or $_.Department -eq "0605" -or $_.Department -eq "0607" -or $_.Department -eq "0614" -or $_.Department -eq "0617" -or $_.Department -eq "0619" -or $_.Department -eq "0621" -or $_.Department -eq "0625" -or $_.Department -eq "0626" -or $_.Department -eq "0632" -or $_.Department -eq "0641" -or $_.Department -eq "0643" -or $_.Department -eq "0645" -or $_.Department -eq "0646" -or $_.Department -eq "0660" -or $_.Department -eq "0664" -or $_.Department -eq "0665" -or $_.Department -eq "0667" -or $_.Department -eq "0670" -or $_.Department -eq "0673" -or $_.Department -eq "0678" -or $_.Department -eq "0682" -or $_.Department -eq "0683" -or $_.Department -eq "0687" -or $_.Department -eq "0688" -or $_.Department -eq "0695" -or $_.Department -eq "0698" -or $_.Department -eq "0699" -or $_.Department -eq "1041" -or $_.Department -eq "1219" -or $_.Department -eq "1602" -or $_.Department -eq "1603" -or $_.Department -eq "1608" -or $_.Department -eq "1609" -or $_.Department -eq "1670" -or $_.Department -eq "1691" -or $_.Department -eq "5844" -or $_.Department -eq "6384"}| Select-Object EmployeeID, DisplayName, Title, extensionAttribute13, Department, UserPrincipalName,  @{Name = 'License'; Expression = {$group}}
 }   
}
$DateTime = Get-Date -f "yyyy-MM" 
$FileName = "IndyOfficeReport"
$CSVFile = "$env:USERPROFILE\Documents\GitHub\Reports\"+$FileName+"_"+$DateTime+".csv"
$output | export-csv -path $csvfile -force -notype 


<#
Get-ADUser : Directory object not found
At C:\Users\914476\Documents\GitHub\ActiveDirectory\IndyLicenseTracking.ps1:42 
char:5
+     Get-ADUser $member -properties * | Where {$_.EmployeeType -eq "In ...
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (CN=1207053,OU=R...anteagle,DC=co 
   m:ADUser) [Get-ADUser], ADIdentityNotFoundException
    + FullyQualifiedErrorId : ActiveDirectoryCmdlet:Microsoft.ActiveDirectory.M 
   anagement.ADIdentityNotFoundException,Microsoft.ActiveDirectory.Management.  
  Commands.GetADUser
 #>