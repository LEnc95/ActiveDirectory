$groupNames = 'O365.Basic','O365.BasicPlus','O365.Standard','O365.StandardPlus','O365.Complete','O365.Executive','SG_All365_Users_K1','SG_All365_Users_F1Base','SG_All365_Indepent_F1base','SG_All365_F1Base_EmailEnabled','SG_All365_Users_F1','SG_All365_Users_E3','SG_All365_Users_E5'

$output = foreach($group in $groupNames)
{
 $members = (Get-ADGroup -Identity  $group -properties members).members
 foreach($member in $members)
 {
    #Get-ADUser $member -properties * | where {$_.Department -eq "0389" -or $_.Department -eq "0600" -or $_.Department -eq "0605" -or $_.Department -eq "0607" -or $_.Department -eq "0614" -or $_.Department -eq "0617" -or $_.Department -eq "0619" -or $_.Department -eq "0621" -or $_.Department -eq "0625" -or $_.Department -eq "0626" -or $_.Department -eq "0632" -or $_.DepartmentNumber -like "*0641*" -or $_.Department -eq "0643" -or $_.Department -eq "0645" -or $_.Department -eq "0646" -or $_.Department -eq "0648" -or $_.Department -eq "0660" -or $_.Department -eq "0664" -or $_.Department -eq "0665" -or $_.Department -eq "0667" -or $_.Department -eq "0670" -or $_.Department -eq "0673" -or $_.Department -eq "0678" -or $_.Department -eq "0682" -or $_.Department -eq "0683" -or $_.Department -eq "0687" -or $_.Department -eq "0688" -or $_.Department -eq "0695" -or $_.Department -eq "0698" -or $_.Department -eq "0699" -or $_.Department -eq "1041" -or $_.Department -eq "1219" -or $_.Department -eq "1602" -or $_.Department -eq "1603" -or $_.Department -eq "1608" -or $_.Department -eq "1609" -or $_.Department -eq "1670" -or $_.Department -eq "1691" -or $_.Department -eq "5844" -or $_.Department -eq "6384"}| Select-Object SamAccountName, EmployeeID, DisplayName, Title, Enabled, Department, UserPrincipalName,  @{Name = 'License'; Expression = {$group}}
    Get-ADUser $member -properties * | where {$_.DepartmentNumber -like "*0641*"}| Select-Object SamAccountName, EmployeeID, DisplayName, Title, Enabled, Department, UserPrincipalName,  @{Name = 'License'; Expression = {$group}}

 }   
}
$DateTime = Get-Date -f "yyyy-MM-dd" 
$FileName = "IndyOfficeReport_0641"
$CSVFile = "C:\Users\914476\Documents\Indy Office Reports\"+$FileName+"_"+$DateTime+".csv"#"$env:USERPROFILE\Documents\Reports\"+$FileName+"_"+$DateTime+".csv"
$CSVFile1 = "S:\IS\Infrastructure Services\Data Security Administration\Public\"+$FileName+"_"+$DateTime+".csv"
$CSVFile2 = "C:\Scheduled Task\MIM\"+$FileName+"_"+$DateTime+".csv"
$CSVFile3 = "\\corp.gianteagle.com\IS\Infrastructure Services\Data Security Administration\Public\"+$FileName+"_"+$DateTime+".csv"
$CSVFile4 = "\\corp.gianteagle.com\common\IS\Infrastructure Services\Data Security Administration\Public\"+$FileName+"_"+$DateTime+".csv"

$output | export-csv -path $CSVFile -force -notype 
$output | export-csv -path $CSVFile1 -force -notype
$output | export-csv -path $CSVFile2 -force -notype  
$output | export-csv -path $CSVFile3 -force -notype  
$output | export-csv -path $CSVFile4 -force -notype 
