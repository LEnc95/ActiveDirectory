$who = Read-Host 'User Name: '
$upn = Get-ADUser -Filter "Name -eq '$who'" | select userPrincipalName
$upn = $upn.userPrincipalName 


Function AzureConnect {
    $UPN = whoami /upn
    Connect-AzureAD -AccountId $UPN
}

Function AzureGetUser {
    Get-AzureADUser -Filter "userPrincipalName eq '$upn'"
}

Function ADuser {
     Get-ADUser -Filter "Name -eq '$who'"
}

ADuser
AzureConnect
AzureGetUser

