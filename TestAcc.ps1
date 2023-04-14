$users = @()
$users = Get-aduser  -Filter {Name -like "*test*"} -Properties * | Select-Object Name, SamAccountName, Enabled, LastLogonDate, PasswordLastSet, whenCreated, whenChanged, extensionAttribute5
$users | Where-Object {
    $_.LastLogonDate -lt (Get-Date).AddDays(-365) -and
    $_.PasswordLastSet -lt (Get-Date).AddDays(-90) -and
    $_.whenCreated -lt (Get-Date).AddDays(-365) -and
    $_.extensionAttribute5 -eq 'IAMManaged'
} | Export-Csv -Path C:\Temp\MIMTestAccountCleanupstatus.csv -NoTypeInformation
#$users | Where-Object {$_.LastLogonDate -lt (Get-Date).AddDays(-90) -and $_.PasswordLastSet -lt (Get-Date).AddDays(-90) -and $_.whenCreated -lt (Get-Date).AddDays(-365) -and $_.extensionAttribute5 -eq 'IAMManaged'} | Export-Csv -Path C:\Temp\TestAccountCleanup_MIM.csv -NoTypeInformation
