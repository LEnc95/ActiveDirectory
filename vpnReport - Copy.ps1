#// Start of script 
#// Get year and month for csv export file 
$DateTime = Get-Date -f "yyyy-MM" 

#// Get all AD groups in the domain 
$GroupName = 'VPN-2Factor-Access'

 
#// Set CSV file name 
$CSVFile = "$env:USERPROFILE\Documents\GitHub\"+$GroupName+"_"+$DateTime+".csv" 
 
 

#$users = Get-AdGroupMember -identity 'VPN-2Factor-Access' | Export-Csv -Path Get-AdGroupMember -identity $CSVFile -Force
Get-AdGroupMember -identity 'VPN-2Factor-Access' | Export-Csv -Path $CSVFile