$report = @("Sip","License")
$users = "luke.encrapera@gianteagle.com", "Brian.Shavensky@gianteagle.com"
#$users = Import-Csv -path "C:\Users\914476\Downloads\TeamsPoliciesExport.csv"
$users | ForEach-Object {
      $upn = ""
      $OfficeSku = ""
      $licenses = ""
      $upn = $_
      $adInfo = Get-aduser -Filter {UserPrincipalName -like $upn} -Properties msDS-ExternalDirectoryObjectId
      $guid = $adInfo.'msDS-ExternalDirectoryObjectId'.Split("_")[1]
      $msolInfo = Get-MsolUser -ObjectId $guid 
      $licenses = $msolInfo.Licenses.AccountSkuId
      if ($licenses -contains "gianteagle:SPE_E5") {
            $OfficeSku = $licenses -like "gianteagle:SPE_E5"
            $report += @($_,$OfficeSku)
            #$_
            #$upn = $_
            #$licenses -like "gianteagle:SPE_E5"
            
      }
      if ($licenses -contains "gianteagle:SPE_F1") {
            $OfficeSku = $licenses -like "gianteagle:SPE_F1"
            $report += @($_,$OfficeSku)
            #$_
            #$upn = $_
            #$licenses -like "gianteagle:SPE_F1"
            $OfficeSku = $licenses -like "gianteagle:SPE_F1"
      }
}
$report
$report | Out-File -FilePath c:/temp/MSlicense.txt