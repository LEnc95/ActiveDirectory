$mypath = $MyInvocation.MyCommand.Path
$parentDir = Split-Path $mypath -Parent

$date = Get-Date -Format yyyyMMdd
$time = get-date -Format HHmm
$fdt = "$date"+"_"+"$time"
####
$phoneNum = "+1 (412) 963-6200" 
#"+1 (412) 963-6200" 
$users = get-aduser -Filter * -Properties OfficePhone | select-object -First 400
$users = $users | Where-Object {$_.officephone -ne $null} | select-object samaccountname, userprincipalname,  officephone
$users | Export-Csv -Path C:\Temp\OfficePhone_20220303.csv -NoTypeInformation

$GEphone = $users | where-object {$_.officephone -like "$phoneNum*"} | select-object Samaccountname, Userprincipalname, OfficePhone

#Get all users with a assosiated telephone number
