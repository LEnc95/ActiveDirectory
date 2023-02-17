$dt = get-date -Format MMddyyyy_hhmmss
$exportPath = "c:\temp\TempNTest_"+$dt+".csv"
$temp = Get-ADUser -Filter {name -like "*temp*"} -Properties lastlogondate | Export-Csv $exportPath -NoTypeInformation -Append
$test = Get-ADUser -Filter {name -like "*test*"} -Properties lastlogondate | Export-Csv $exportPath -NoTypeInformation -Append


