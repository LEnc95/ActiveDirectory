$users = @()
$user = ''
$entitlement = ''
$users = Import-Csv -Path 'C:\Users\914476\OneDrive - Giant Eagle, Inc\Documents\New_Hire_Employment.csv'
$group = "O365.Complete","O365.Standard","O365.StandardPlus","O365.BasicPlus","O365.Basic","O365.Executive" 

foreach ($group in $groups) {
    $members = Get-ADGroupMember -Identity $group -Recursive | Select-Object -ExpandProperty Name
    ForEach ($user in $users) {
        If ($members -contains $user.TeamMemberID) {
        Write-Host "$user exists in the $group`n" #| Out-File -FilePath "C:\Users\914476\OneDrive - Giant Eagle, Inc\Documents\EMER_LicenseAssignment.txt" -Append
    } Else {
        #Write-Host "$user not exists in the $group"
    }}
}