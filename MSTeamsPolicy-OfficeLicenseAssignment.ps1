<# Solution 0 ########################################################################################>
<#
$Groups_global = "O365.Executive", "O365.Complete"
$Groups_kiosk = "O365.Standard", "O365.StandardPlus", "O365.Basic", "O365.BasicPlus"
$groups = "O365.Executive", "O365.Complete", "O365.Standard", "O365.StandardPlus", "O365.Basic", "O365.BasicPlus"
$group = "O365.Complete"
$users_in = "914476"
$members = @()

$users_in | ForEach-Object {
      $users += Get-ADUser $users_in -Properties SamaccountName, UserPrincipalName, DisplayName
}

$groups | ForEach-Object {
      $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty Name
      $users | ForEach-Object {
      $user = $_.Name
      If ($members -contains $user) {
            Write-Host "$_.Displayname exists in the group $group[$_].DisplayName"
      } Else {
            Write-Host "$_.DisplayName not exists in the group $group[$_].DisplayName"
      }}      
}
#>
<# Solution 1 ########################################################################################>
<#
$users = Import-Csv -path "C:\Users\914476\Downloads\TeamsPoliciesExport.csv"
$users | foreach-object {
      $_.SipAddress.Split(":")[1]
}

$obj = New-Object -TypeName [PSCustomObject]@{
      Name = "Name"#$userUPN[$_]
      License = "E5" #$_.SkuPartNumber
}

$properties = @{
      UPN = "UPN"
      License = "E5"
}
$properties
                              #$properties | Add-Member -MemberType NoteProperty -Name UPN -value "$userUPN[$_]"
                              #$obj | Add-Member -MemberType NoteProperty -Name Name -value "$userUPN[$_]"
                              #$properties | Add-Member -MemberType NoteProperty -Name License -value "$_.SkuPartNumber"

#>
<# Solution 2 ########################################################################################>
<#
$report = @(("UPN","License"),("Luke","E9"))
#$add = @()
$userUPN = @()
$userUPN += "Brian.Shavensky@gianteagle.com","luke.encrapera@gianteagle.com"
$licensePlanList = Get-AzureADSubscribedSku
#$userUPN | ForEach-Object {
foreach ($user in $userUPN) {
      $userList = Get-AzureADUser -ObjectID "$user" | Select-Object -ExpandProperty AssignedLicenses | Select-Object SkuID 
      $userList | ForEach-Object { 
            $sku = $_.SkuId ; $licensePlanList | ForEach-Object { 
                  If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36)) { 
                        #Write-Host $_.SkuPartNumber 
                        if ($_.SkuPartNumber -ieq "SPE_E5") {
                              Write-Host "$user", "E5"
                              #$report +=  @(("UPN","$user"),("License","E5"))
                              $report +=  @(("$user", "E5"))
                              #$add = "$user", "E5"
                              #$report = $report, $add
                              #$add = @()
                        }
                        if ($_.SkuPartNumber -ieq "SPE_E3") {
                              Write-Host "$user", "E3"
                              #$report += @(("UPN","$user"),("License","E3"))
                              $report +=  @(("$user", "E3"))
                              #$add = "$user", "E3"
                              #$report = $report, $add
                              #$add = @()
                        }
                        if ($_.SkuPartNumber -ieq "SPE_F1") {
                              Write-Host "$user", "F3"
                              #$add = "$user", "F3"
                              #$report = $report, $add
                              #$add = @()
                        }
                        if ($_.SkuPartNumber -ieq "DESKLESSPACK") {
                              Write-Host "$user", "F1"
                              #$add = "$user", "F1"
                              #$report = $report, $add
                              #$add = @()
                        }else {
                              #Write-Host "Not licensed"
                        }
                  } 
            } 
      }
}
#$report
#>
<# Solution 3 ########################################################################################>
<#Start
$groupNames = 'O365.Complete','O365.Executive' #'O365.Basic','O365.BasicPlus','O365.Standard','O365.Complete','O365.Executive','SG_All365_Users_K1','SG_All365_Users_F1Base','SG_All365_F1Base_EmailEnabled','SG_All365_Users_F1','SG_All365_Users_E3','SG_All365_Users_E5'
$userUPN = "Brian.Shavensky@gianteagle.com","luke.encrapera@gianteagle.com"

$output = foreach($group in $groupNames)
{
 $members = (Get-ADGroup -Identity  $group -properties members).members
 foreach($member in $members)
 {
    Get-ADUser $member -properties * | Where-Object {$_.UserPrincipalName -ieq $userUPN}| Select-Object EmployeeID, DisplayName, Title, extensionAttribute13, Department, UserPrincipalName,  @{Name = 'License'; Expression = {$group}}
 }   
}
$DateTime = Get-Date -f "yyyy-MM-dd" 
$FileName = "LicenseReport"
$CSVFile = "$env:USERPROFILE\OneDrive - Giant Eagle, Inc\Documents\GitHub\Reports\"+$FileName+"_"+$DateTime+".csv"
$output | export-csv -path $csvfile -force -notype 
End#>
#Connect-MsolService

$report = @("Sip", "License")
#$users = "luke.encrapera@gianteagle.com", "Brian.Shavensky@gianteagle.com"
$users = Import-Csv -path 'C:\Users\914476\OneDrive - Giant Eagle, Inc\Documents\teamFiltered.csv' #"C:\Users\914476\Downloads\TeamsPoliciesExport.csv"
$users | ForEach-Object {
      $upn = ""
      $OfficeSku = ""
      $licenses = ""
      $upn = $_.SipAddress.Split(":")[1]
      try { 
            $adInfo = Get-aduser -Filter { UserPrincipalName -like $upn } -Properties msDS-ExternalDirectoryObjectId 
            $guid = $adInfo.'msDS-ExternalDirectoryObjectId'.Split("_")[1]
            $msolInfo = Get-MsolUser -ObjectId $guid 
            $licenses = $msolInfo.Licenses.AccountSkuId
            if ($licenses -contains "gianteagle:SPE_E5") {
                  $OfficeSku = $licenses -like "gianteagle:SPE_E5"
                  $OfficeSku = $OfficeSku.Split(":")[1]
                  $report += @($upn, $OfficeSku)
      
            }
            if ($licenses -contains "gianteagle:SPE_F1") {
                  $OfficeSku = $licenses -like "gianteagle:SPE_F1"
                  $OfficeSku = $OfficeSku.Split(":")[1]
                  $report += @($upn, $OfficeSku)
      
            }
      
      }
      Catch {
            #$adInfo = $upn
            $report += @($upn, "No user with UPN")
      }
}
$report
$report | Out-File -FilePath c:/temp/MSlicense.txt