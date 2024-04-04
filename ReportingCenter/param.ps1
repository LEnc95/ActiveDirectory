# param.ps1

#request user input to set the user to search for
$who = Read-Host "Search user with - User ID, First or Last Name, UPN or Email"

#function to get $who user data from AD and Azure and output the results to html file 


#Connect Azure
#$UPN = Get-ADUser $env:USERNAME | select UserPrincipalName
#Connect-AzureAD -AccountId $UPN.UserPrincipalName
