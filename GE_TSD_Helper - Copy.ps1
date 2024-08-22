<#
### Title: Active Directory Helper & Automation
### Author: Luke Encrapera
### Email: Luke.Encrapera@gianteagle.com
### Date: 3/4/2020
#>

Import-Module ActiveDirectory #Import AD
Write-Host "
   _____ _             _     ______            _      
  / ____(_)           | |   |  ____|          | |     
 | |  __ _  __ _ _ __ | |_  | |__   __ _  __ _| | ___ 
 | | |_ | |/ _` | '_ \| __| |  __| / _` |/ _` | |/ _ \
 | |__| | | (_| | | | | |_  | |___| (_| | (_| | |  __/
  \_____|_|\__,_|_| |_|\__| |______\__,_|\__, |_|\___|
                                          __/ |       
                                         |___/        
                                         "
########RRRUUUNNN#########
do{ #Infinite Loop
$userInput = Read-Host "TMID" #Take user input
$TMID = $userInput #If user input is TMID, vdr, dev, srv, legacy converts user input to store id in TMID
    try{

    #Temporary cache user data
    $userdata = Get-ADUser $TMID -Properties *

    #Displays user information
    #Display user data
    $userdata.SamAccountName,$userdata.DisplayName,$userdata.EmailAddress,$userdata.telephoneNumber,$userdata.Company,$userdata.Description,$userdata.Department, $userdata.employeeType

    #Unlock User AD Account
    #Alert and automatically unlock a users account
    if($userdata.LockedOut){Write-Host $TMID,"is locked out" -ForegroundColor Red
        Write-Host "Unlocking",$TMID -ForegroundColor Yellow
        Unlock-ADAccount $TMID
        Write-Host $TMID,"Unlocked" -ForegroundColor Green                          
    }

    #Alert and automatically enable a disbaled account
    if($userdata.Enabled -ne $true){Write-Host $TMID,"is not yet enabled" -ForegroundColor Red
            $yn = Read-Host "Enable Account for $TMID (Y/n)?" 
            $yn = $yn.ToUpper()
            if($yn -eq "Y"){#Update password prompt
                Write-Host "Enableing Account" -ForegroundColor Yellow
                Enable-ADAccount $TMID
                Write-Host "Account Enabled" -ForegroundColor Green
            }
    }   

    #Alert password has expired and the last updated date and then prompt input for a new password
    if($userdata.PasswordExpired){Write-Host $TMID,"password has expired.", "Last set" + $userdata.PasswordLastSet -ForegroundColor Red
        $yn = Read-Host "Update Password for $TMID (Y/n)?" 
        $yn = $yn.ToUpper()
        if($yn -eq "Y"){#Update password prompt
            $pwd=Read-Host "New Password"
            Set-ADAccountPassword $TMID -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $pwd -Force)
            Write-Host $TMID,"Password has been updated" -ForegroundColor Green
        }else{}#No change to password
    }
    
}catch{"Could not find an account for $TMID"}
}while($true)  


