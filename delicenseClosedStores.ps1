$groups= @()
$users = @()
$inactive = @()
$groups += Get-ADGroup -Filter {name -like "Office 365 Basic Plus - Generic*" -and name -notlike "office 365 basic plus - generic fuel manager" -and name -notlike "Office 365 Basic Plus - Generic Break Glass"}
$groups | ForEach-Object {
    $users += Get-ADGroupMember $_.Name
}
$users | ForEach-Object {
    $inactive += Get-aduser -Identity $_.SamAccountName -Properties Name, SamAccountName, lastlogondate | Select-Object Name, SamAccountName, lastlogondate | Where-Object { $_.lastLogonDate -lt ((Get-Date).AddDays(-360)).Date }
}
$users.Count
$inactive.count
foreach ($user in $inactive) {
    $groups | ForEach-Object {
        try {
            Remove-ADGroupMember -Identity $_ -Members $user.SamAccountName -Confirm:$false
            Write-Host "removed $($user.name) from $($_.name)"
        }
        catch {
            Write-Host "$($user.name) not memberOf $($_.name)"
        }
    }
}
