#(Get-ADGroup "O365.Standard" -properties members).members |Get-ADUser -properties displayName, extensionAttribute7 | Where-Object {$_.extensionAttribute7 -like "GetGo*"} | Export-Csv -Path "C:\Temp\GetGo-Standard.csv" -NoTypeInformation
#(Get-ADGroup "O365.Executive" -properties members).members |Get-ADUser -properties displayName, extensionAttribute7 | Where-Object {$_.extensionAttribute7 -like "GetGo*"} | Export-Csv -Path "C:\Temp\GetGo-Executive.csv" -NoTypeInformation
#(Get-ADGroup "O365.Basic" -properties members).members |Get-ADUser -properties displayName, extensionAttribute7 | Where-Object {$_.extensionAttribute7 -like "GetGo*"} | Export-Csv -Path "C:\Temp\GetGo-Basic.csv" -NoTypeInformation
(Get-ADGroup "O365.BasicPlus" -properties members).members |Get-ADUser -properties displayName, extensionAttribute7 | Where-Object {$_.extensionAttribute7 -like "GetGo*"} | Export-Csv -Path "C:\Temp\GetGo-BasicPlus.csv" -NoTypeInformation
(Get-ADGroup "O365.Complete" -properties members).members |Get-ADUser -properties displayName, extensionAttribute7 | Where-Object {$_.extensionAttribute7 -like "GetGo*"} | Export-Csv -Path "C:\Temp\GetGo-Complete.csv" -NoTypeInformation

