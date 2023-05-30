$users = Get-ADGroupMember -Identity "SG_Expired_Accounts"
$report = @()
$users | foreach-object {
                        $report += Get-ADUser $_ -Properties name, memberof | Where-Object {$_.memberof -contains "CN=Office 365 Basic,OU=Managed,OU=RBAC,DC=corp,DC=gianteagle,DC=com" -and $_.Enabled -eq $true} | Select-Object name, @{name="MemberOf";expression={$_.memberof -join ";"}
                    } 
                    $report | Export-Csv C:\Temp\basiclicense_expiredaccounts_enabledonly.csv -NoTypeInformation -Encoding UTF8}