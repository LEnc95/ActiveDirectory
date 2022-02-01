<##########
### Title: Remove Office Group Membership
### Author: Luke Encrapera
### Email: Luke.Encrapera@GiantEagle.com
### Date: 12/14/2021
##########>

<#  USAGE:
    Remove users from office groups they are a member of on prem.
    Any groups with dynamic membership will sync back on the following sync.
    Only manual groups will be lost. 
    Dynamic will only filter out once employees status changes to term or deleted. 
    Sign in to Azure after launching the script.
#>
Connect-AzureAD
do {
    $user = Read-Host "Enter users SamAccountName"
    Write-Host "Getting users group membership" -ForegroundColor Yellow
    $user = Get-aduser $user -Properties MemberOf
    $groups = @()
    $user.MemberOf | ForEach-Object {
        $groups += $_
    }
    $Remove = @()
    $groups | ForEach-Object {
        if ($_ -like "*CN=Group_*") {
            $Remove += $_
            Write-Host $_ -ForegroundColor Red
        } 
        else {
            Write-Host $_ -ForegroundColor Green
        }
    }
    $Remove | ForEach-Object {
        $delete = $_.Split("=")[1]
        $delete = $delete.Split(",")[0]
        #Remove-ADGroupMember -Identity $delete -Members $user
        Write-Host "Removed membership from $delete" -ForegroundColor Yellow
        $azure = Get-AzureADMSGroup -Id $delete.Split("_")[1] | Select-Object DisplayName, Mail
        Write-Host "$azure" -ForegroundColor Yellow
    }
} while ($true)
