#pipeAD
$match = Get-ADUser -Filter * -Properties * | select-object -First 100 | select-object samaccountname, extensionAttribute6 | Where-Object {$_.extensionAttribute6 -like "*|AD*"} 
$match.samaccountname
$match.extensionAttribute6.Split(";") 
$results = [PSCustomObject]@{
    accountName = $match.samaccountname
    pipeAD = $match.extensionAttribute6.Split(";") 
}