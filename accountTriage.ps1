# get ad user and make sure they dont have common account issues 972637
 $user  = 972637
$ad = Get-ADUser -Filter {SamAccountName -eq $user} -Properties *
#check if user is locked
if ($ad.LockedOut -eq $true) {
    Write-Host "User is locked out"
}
#check if user is disabled
if ($ad.Enabled -eq $false) {
    Write-Host "User is disabled"
}
#check if user is expired
if ($ad.AccountExpirationDate -lt (Get-Date)) {
    Write-Host "User account is expired"
}
#check if user is password expired
if ($ad.PasswordExpired -eq $true) {
    Write-Host "User password is expired"
}
#check if user is password never expires
if ($ad.PasswordNeverExpires -eq $true) {
    Write-Host "User password never expires"
}
#check if user is password not required
if ($ad.PasswordNotRequired -eq $true) {
    Write-Host "User password not required"
}
#check if member of sg_expired_accounts
$sg = Get-ADGroupMember -Identity sg_expired_accounts
if ($sg -contains $ad) {
    Write-Host "User is a member of sg_expired_accounts"
}

#check if user is in azure
$az = Get-AzureADUser -ObjectId $ad.ObjectID
if ($az -eq $null) {
    Write-Host "User is not in Azure"
}
#check if any sign in issues in azure
$signins = Get-AzureADAuditSignInLogs -Filter "userPrincipalName eq '$ad.UserPrincipalName'"
if ($signins -ne $null) {
    Write-Host "User has sign in issues"
}
