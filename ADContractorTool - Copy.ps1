<######################################  
#SYNOPSIS  
#     Imports CSV file of users for creation in AD
#DESCRIPTION   
#    Creates users from import file into AD setting required values.Defaults to Contractors OU and sets random ID and password.
#NOTES  
#    File Name  : ADContractorTool.ps1  
#    Author     : Luke Encrapera
#    Email      : luke.encrapera@gianteagle.com
#    Requires   : PowerShell V2+  
#Documentation can be found in About.txt     
######################################>

#Project Requirements
#AD Requirements:

#First Name (GivenName in AD PowerShell)
#Last Name (Surname in AD PowerShell)
#UserPrincipalName
#SamAccountName (99 and then another 5 random numbers)
#Password (Randomized, I believe it requires one uppercase letter, one lowercase, a number and a special character)
#Description set to “Ready for MIM Script” (I can use this to target them in batches depending on how many contractors we have in a day)
#Expiration Date

#Syntax guide
<#
New-ADUser [-Name] <string> [-WhatIf] [-Confirm] [-AccountExpirationDate <datetime>] [-AccountNotDelegated <b
ool>] [-AccountPassword <securestring>] [-AllowReversiblePasswordEncryption <bool>] [-AuthenticationPolicy <A
DAuthenticationPolicy>] [-AuthenticationPolicySilo <ADAuthenticationPolicySilo>] [-AuthType <ADAuthType>] [-C
annotChangePassword <bool>] [-Certificates <X509Certificate[]>] [-ChangePasswordAtLogon <bool>] [-City <strin
g>] [-Company <string>] [-CompoundIdentitySupported <bool>] [-Country <string>] [-Credential <pscredential>] 
[-Department <string>] [-Description <string>] [-DisplayName <string>] [-Division <string>] [-EmailAddress <s
tring>] [-EmployeeID <string>] [-EmployeeNumber <string>] [-Enabled <bool>] [-Fax <string>] [-GivenName <stri
ng>] [-HomeDirectory <string>] [-HomeDrive <string>] [-HomePage <string>] [-HomePhone <string>] [-Initials <s
tring>] [-Instance <ADUser>] [-KerberosEncryptionType <ADKerberosEncryptionType>] [-LogonWorkstations <string
>] [-Manager <ADUser>] [-MobilePhone <string>] [-Office <string>] [-OfficePhone <string>] [-Organization <str
ing>] [-OtherAttributes <hashtable>] [-OtherName <string>] [-PassThru] [-PasswordNeverExpires <bool>] [-Passw
ordNotRequired <bool>] [-Path <string>] [-POBox <string>] [-PostalCode <string>] [-PrincipalsAllowedToDelegat
eToAccount <ADPrincipal[]>] [-ProfilePath <string>] [-SamAccountName <string>] [-ScriptPath <string>] [-Serve
r <string>] [-ServicePrincipalNames <string[]>] [-SmartcardLogonRequired <bool>] [-State <string>] [-StreetAd
dress <string>] [-Surname <string>] [-Title <string>] [-TrustedForDelegation <bool>] [-Type <string>] [-UserP
rincipalName <string>] [<CommonParameters>]
#>

#path to your import CSV file
$ADUsers = Import-csv C:\Users\914476\Documents\WindowsPowerShell\Scripts\newusers.csv

$OU = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"
foreach ($User in $ADUsers)
{
#Pick EmployeeID and check availability       
        $AlreadyExists = $True
        While ($AlreadyExists)  {
            $AlreadyExists = $false
            $CurrentRandomNumber = <#914476#> Get-Random -Maximum 919999 -Minimum 910000
	            if (Get-ADUser -F {SamAccountName -eq $CurrentRandomNumber}) {
	                $AlreadyExists = $true
            Write-Host $CurrentRandomNumber, 'Already exists!'
	            }
	            else  {
	                $AlreadyExists = $false
                    Write-Host $CurrentRandomNumber, 'Does not exist!'
	            }
	        }
    Write-Host $CurrentRandomNumber, 'Will be used as the employeeID'
    
    $Username = $CurrentRandomNumber # Set employeeID to $username
      <# $Username    = $User.username #>
#Set password to a random compliant password
       add-type -AssemblyName System.Web
        $minLength = 64 ## characters
        $maxLength = 128 ## characters
        $length = Get-Random -Minimum $minLength -Maximum $maxLength
        $nonAlphaChars = 5
        $password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
        Write-Host 'Temp pass set ', $password
       #$Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
    $Department = $User.department
       <#$OU           = $User.ou#>

       #Check if the user account already exists in AD again
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              #If a user does not exist then create a new user account
          
        #Account will be created in the OU listed in the $OU variable in the CSV file;
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Firstname.$Lastname@gianteagle.com" `
            -Name "$Username" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -Description "Ready for MIM Script" `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}