Import-Module ActiveDirectory

$users = Get-ADGroupMember -Identity "MIM_AccountsToDelete" | Get-ADUser -Properties lastlogondate, passwordlastset, whenchanged

$report = foreach ($user in $users) {
    $lastLogonDate = $user.lastlogondate
    $passwordLastSet = $user.passwordlastset
    $whenChanged = $user.whenchanged

    [PSCustomObject]@{
        User = $user.Name
        LastLogonDate = $lastLogonDate
        PasswordLastSet = $passwordLastSet
        WhenChanged = $whenChanged
    }
}

$report | Export-Csv -Path "C:\temp\MIMAccountsToDelete_report.csv" -NoTypeInformation
