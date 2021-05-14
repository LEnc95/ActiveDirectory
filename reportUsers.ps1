$report= @()
$users = 2032290, 1089731, 2035879, 1108231, 1141982, 2001002, 1152728, 2027961, 1153456, 1223632, 2031466, 1188417, 2002633, 1109209
foreach($user in $users){$report += Get-ADuser $user}
$report | Export-Csv -Path C:\temp\MFAblockedUsers.csv -NoTypeInformation