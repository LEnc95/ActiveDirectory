#import user data
$userData = Import-Csv -Path C:\Temp\ADtestAccountCleanup.csv
$disable = $userData | Where-Object Enabled -EQ "True"
foreach ($user in $disable){
    $samaccountname = $user.samaccountname
    $samaccountname
    Set-ADUser -Identity $samaccountname -Enabled $false
}