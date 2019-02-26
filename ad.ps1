<#
### Title: Active Directory Helper & Automation
### Author: Luke Encrapera
### Email: Luke.Encrapera@dcsg.com
### Date: 1/9/2019
#>

Import-Module ActiveDirectory #Import AD

#Temporary cache user data
function CacheUserData()
    {
        $userdata = Get-ADUser $dks -Properties *
    }

#Displays user information
function GetUsersData 
    {
        #Display user data
        $userdata.SamAccountName,$userdata.DisplayName,$userdata.EmailAddress, $userdata.telephoneNumber,$userdata.Company,$userdata.Description,$userdata.Department
    }

#Unlock User AD Account
function Unlock()
    {
        #Alert and automatically unlock a users account
        if($userdata.LockedOut){Write-Host $dks,"is locked out" -ForegroundColor Red
            Write-Host "Unlocking",$dks -ForegroundColor Yellow
            Unlock-ADAccount $dks
            Write-Host $dks,"Unlocked" -ForegroundColor Green                          
        }
    }

function Enable()
    {
        #Alert and automatically enable a disbaled account
        if($userdata.Enabled -ne $true){Write-Host $dks,"is not yet enabled" -ForegroundColor Red
                $yn = Read-Host "Enable Account for $dks (Y/n)?" 
                $yn = $yn.ToUpper()
                if($yn -eq "Y"){#Update password prompt
                    Write-Host "Enableing Account" -ForegroundColor Yellow
                    Enable-ADAccount $dks
                    Write-Host "Account Enabled" -ForegroundColor Green
                }
        }   
    }

function ResetPassword()
    {
        #Alert password has expired and the last updated date and then prompt input for a new password
        if($userdata.PasswordExpired){Write-Host $dks,"password has expired.", "Last set" + $userdata.PasswordLastSet -ForegroundColor Red
            $yn = Read-Host "Update Password for $dks (Y/n)?" 
            $yn = $yn.ToUpper()
            if($yn -eq "Y"){#Update password prompt
                $pwd=Read-Host "New Password"
                Set-ADAccountPassword $dks -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $pwd -Force)
                Write-Host $dks,"Password has been updated" -ForegroundColor Green
            }else{}#No change to password
        }  
    }

########RRRUUUNNN#########
do{ #Infinite Loop
$userInput = Read-Host "DKS" #Take user input
$dks = $userInput #If user input is dks, vdr, dev, srv, legacy converts user input to store id in dks
    try{
            CacheUserData($dks)
            GetUsersData($dks)
            Enable($dks)
            Unlock($dks)
            ResetPassword($dks)
        }catch{"Could not find an account for $dks"}
}while($true)



