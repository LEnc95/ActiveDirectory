$date = Get-Date -Format "MM-dd-yyyy"
$users = Import-Csv -Path C:\Users\914476\Documents\GitHub\_infile\hatchdlogoncomp.csv
@(foreach($user in $users){Get-ADUser $user.samaccountname -Properties * | select samaccountname, displayname, lastLogon, LastLogonDate, LastLogonTimestamp}) | Export-Csv -Path .\Documents\GitHub\_outfile\hatchdlogoncomp_$date.csv

foreach($user in $users){
    get-aduser $user.samaccountname -Properties * | select samaccountname, displayname, lastLogon, LastLogonDate, LastLogonTimestamp
}