#TSD Helper
<#
───▄▄▄
─▄▀░▄░▀▄
─█░█▄▀░█
─█░▀▄▄▀█▄█▄▀
▄▄█▄▄▄▄███▀
#>
$ge = {
░██████╗░██╗░█████╗░███╗░░██╗████████╗  ███████╗░█████╗░░██████╗░██╗░░░░░███████╗
██╔════╝░██║██╔══██╗████╗░██║╚══██╔══╝  ██╔════╝██╔══██╗██╔════╝░██║░░░░░██╔════╝
██║░░██╗░██║███████║██╔██╗██║░░░██║░░░  █████╗░░███████║██║░░██╗░██║░░░░░█████╗░░
██║░░╚██╗██║██╔══██║██║╚████║░░░██║░░░  ██╔══╝░░██╔══██║██║░░╚██╗██║░░░░░██╔══╝░░
╚██████╔╝██║██║░░██║██║░╚███║░░░██║░░░  ███████╗██║░░██║╚██████╔╝███████╗███████╗
░╚═════╝░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░  ╚══════╝╚═╝░░╚═╝░╚═════╝░╚══════╝╚══════╝
} 
Write-Host $ge -ForegroundColor Red

Function getuser($who){

    #Connect Azure
    $UPN = Get-ADUser $env:USERNAME | select UserPrincipalName
    Connect-AzureAD -AccountId $UPN.UserPrincipalName
    
    #Prompt for user
    $who = Read-Host "Search user with - User ID, First or Last Name, UPN or Email"
    
    #User lookup
    $FilterLogic = {name -like $who -or Surname -like $who -or UserPrincipalName -like $who -or SamAccountName -like $who -or GivenName -like $who} #DN filter CN     @{l='CN';e={$_.DistinguishedName.split(',')[1].split('=')[1]}}
    $userdata = Get-ADUser -Filter $FilterLogic -Properties * #| select Created, EmployeeID, CN, DisplayName, Title, EmailAddress, proxyAddresses, extensionAttribute1, DistinguishedName, Enabled, extensionAttribute3, LockedOut, lockoutTime, AccountExpirationDate
    
    #Get Users Manager
    $managertable = Get-ADUser $userdata.CN -Properties title, department, manager | Select-Object title, department, @{name='ManagerName';expression={(Get-ADUser -Identity $_.manager | Select-Object -ExpandProperty name)}},@{name='ManagerEmailAddress';expression={(Get-ADUser -Identity $_.manager -Properties emailaddress | Select-Object -ExpandProperty emailaddress)}} | Format-list

    #Get Azure user data
    $azuredata = Get-AzureADUser -ObjectId $userdata.UserPrincipalName

    #Azure license assignment 

    #Azure Extention attribute
    $azureextension = Get-AzureADUserExtension -ObjectId $userdata.UserPrincipalName 

    #Azure Manager
    $AzureManager = Get-AzureADUserManager -ObjectId luke.encrapera@gianteagle.com 

    #Azure User Group Membership Report
    $AzureMembership = Get-AzureADUserMembership -ObjectId luke.encrapera@gianteagle.com
    
    #Azure User Devices
    $AzureOwnedDevice = Get-AzureADUserOwnedDevice -ObjectId luke.encrapera@gianteagle.com
    $AzureRegisteredDevice = Get-AzureADUserRegisteredDevice -ObjectId luke.encrapera@gianteagle.com   

    #Output 
    #Clear-Host
    Write-Host $ge -ForegroundColor Red
    #$ge
    #$userdata.UserPrincipalName
    #$userdata.DisplayName
    Get-ADUser -Filter $FilterLogic -Properties * | select Created, EmployeeID, CN, DisplayName, Title, EmailAddress, proxyAddresses, extensionAttribute1, DistinguishedName, Enabled, extensionAttribute3, LockedOut, lockoutTime, AccountExpirationDate
    $managertable
    $azuredata
    #$azureextension
    #$AzureManager
    #$AzureMembership
    #$AzureOwnedDevice
    #$AzureRegisteredDevice

        Write-Host {
    🆃🆂🅳 🅷🅴🅻🅿🅴🆁 
    To report bugs or request new features please email luke.encrapera@gianteagle.com
    }
}
#Infinite loop
while($true){
getuser 
Read-Host 'Enter to loop'
}
