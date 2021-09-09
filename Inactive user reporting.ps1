# get memebers of all licensed groups except basic
# Get all users accounts where lastLogonDate is -ge 60days
<# 
$users
$users += Get-ADGroupMember -Identity "O365.Complete"
$users += Get-ADGroupMember -Identity "O365.Standard"
$users += Get-ADGroupMember -Identity "O365.StandardPlus"
$users += Get-ADGroupMember -Identity "O365.BasicPlus"
$users += Get-ADGroupMember -Identity "O365.Executive" 
Get-ADGroup
foreach ($user in $users){
    #where lastlogon exceeds 90 days
}
$users | Export-Csv -Path C:\Temp\inactive.csv
#>
<#
ForEach ($group in $groups){
    ForEach($OU in $OUs){
        $OU_name = $OU.Split("=").split(",")[1]
    }
    $CSVFile = "$env:USERPROFILE\OneDrive - Giant Eagle, Inc\Documents\GitHub\Reports\"+$group+"_"+$OU_name+"_"+$DateTime+".csv" 
    Get-ADGroup $group -Properties Member |
        Select-Object -Expand Member |
        Get-ADUser -SearchScope $OU -Property msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName | Export-Csv -Path $CSVFile -NoTypeInformation -Force | Out-String -Width 10000
    Write-Host $group " has been exported to " $CSVFile
}
#>
#Get-ADUser -filter * -searchBase $OU[0]

#Import-Module Microsoft.graph   
#New-MgTeamChannelMessage -TeamId "0a2787af-3119-4bb0-aa65-ee8271fe2db5" -ChannelId "19:33ef240236f04f43aebfbb60032d1573@thread.skype" -Body @{ Content="Hello World" }

#Declare Variables
$DateTime = Get-Date -f "yyyy-MM-dd"
$groups = "O365.Complete","O365.Standard","O365.StandardPlus","O365.BasicPlus","O365.Executive" 
$OUs = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com","OU=Corporate Users,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com" 
$users = @()
$inactive = @()

#Secret Server Start
function Get-SecretServerCredential {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [Alias('Name')]
                  [string]$SecretName,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [Alias('ID')]
                  [int]$SecretID,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [System.Management.Automation.PSCredential]$Credentials,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [Alias('ComputerName')]
                  [string]$SecretServerName = 'creds.gianteagle.com',
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [switch]$TLS12,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [switch]$oAuth

    )
    if($TLS12) {
	    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }
    if($SecretID -and $SecretName) {
        Write-Host 'Both ID and Name provided, using just the ID.'
    }
    $BaseURL = https://$SecretServerName/SecretServer
    $Arglist = @{}
    if($oAuth) {
        try {
            $Arglist['Headers'] = @{Authorization = "Bearer $((Invoke-RestMethod "$BaseURL/oauth2/token" -Method Post -Body @{username = $Credentials.UserName; password = $Credentials.GetNetworkCredential().Password; grant_type = 'password'} -ErrorAction Stop).access_token)"}
        } catch {
            throw $_
        }
        $BaseURL += '/api/v1/secrets'
    } else {
        $BaseURL += '/winauthwebservices/api/v1/secrets'
        $Arglist['UseDefaultCredentials'] = $true
    }

    if($SecretID) {
        $SecretServerSecretID = $SecretID
    } elseif($SecretName) {
        $Arglist['Uri'] = "$($BaseURL)?filter.searchText=$SecretName"
        Write-Verbose 'Getting Secret ID:'
        $Arglist | Out-String | Write-Verbose
        $SecretServerSecretID = ((Invoke-RestMethod @Arglist).records | Where-Object {$_.name -eq $SecretName}).id
        Write-Verbose "Getting Secret ID: $SecretServerSecretID"
        if($SecretServerSecretID -eq $null) {
            throw 'No Secret Found!'
        }
    } else {
        throw 'No Secret Identifier found, Please provide an ID or Name.'
    }

    $Arglist['Uri'] = "$BaseURL/$SecretServerSecretID"
    
    Write-Verbose 'Getting Secret:'
    $Arglist | Out-String | Write-Verbose
    $SecretServerSecret   = Invoke-RestMethod @Arglist
    $SecretServerPassword = ($SecretServerSecret.items | Where-Object {$_.slug -eq 'password'}).itemValue | ConvertTo-SecureString -asPlainText -Force
    $SecretServerUserName = ($SecretServerSecret.items | Where-Object {$_.slug -eq 'username'}).itemValue
    if($SecretServerUserName -like '') {
        $SecretServerUserName = '<null>'
    }
    $SecretServerDomainName = ($SecretServerSecret.items | Where-Object {$_.slug -eq 'domain'}).Value
    if($SecretServerDomainName -notlike '') {
        $SecretServerUserName = "$SecretServerDomainName\$SecretServerUserName"
    }
    $SecretServerCredentials = New-Object System.Management.Automation.PSCredential($SecretServerUserName,$SecretServerPassword)
    return $SecretServerCredentials
}

[System.Management.Automation.PSCredential]$API_Keys = Get-SecretServerCredential -SecretID 31940 -TLS12
# Secret Server End

#Get active users by OU
ForEach($OU in $OUs){
    $OU_name = $OU.Split("=").split(",")[1]
    $CSVFile = "$env:USERPROFILE\OneDrive - Giant Eagle, Inc\Documents\GitHub\Reports\"+$OU_name+"_"+$DateTime+".csv" 
    $users += Get-ADUser -Filter * -SearchBase $OU -Property msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName, lastLogonDate | Where-Object enabled -EQ $TRUE
    $users | Export-Csv -Path $CSVFile -NoTypeInformation -Force | Out-String -Width 10000
    Write-Host $OU " has been exported to " $CSVFile
}

#Foreach user if lastlogondate exceeds 90 days pull sign ins from Azure. 
ForEach($user in $users){
    #$user = Get-aduser $user.SamAccountName -Properties *
    if($user.lastLogonDate -lt (Get-Date).AddDays(-90)){
        $inactive += $user
        #https://graph.microsoft.com/beta/users?$filter=startswith(displayName,'$user.SamAccountName')&$select=displayName,signInActivity
    }
}
$CSVFile = "$env:USERPROFILE\OneDrive - Giant Eagle, Inc\Documents\GitHub\Reports\Inactive_"+$DateTime+".csv" 
$inactive | Export-Csv -Path $CSVFile -NoTypeInformation -Force | Out-String -Width 10000

#$Users = @('bkamis@gianteagle.onmicrosoft.com','bmcclure@gianteagle.onmicrosoft.com','NonExistantUser@gianteagle.com','AnotherNonExistantUser@gianteagle.com')
$InactiveUsers = @()
$inactive | ForEach-Object {
    #region Authentication
    $ClientID              = $API_Keys.UserName
    $ClientSecret          = $API_Keys.GetNetworkCredential().Password
    $TenantDomain          = 'fe7b0418-5142-4fcf-9440-7a0163adca0d'
    $LoginURL              = 'https://login.microsoft.com'
    $Resource              = 'https://graph.microsoft.com'
    $TokenRequestBody      = @{grant_type="client_credentials";resource=$Resource;client_id=$ClientID;client_secret=$ClientSecret}
    $oAuth                 = Invoke-RestMethod -Method Post -Uri $LoginURL/$TenantDomain/oauth2/token?api-version=1.0 -Body $TokenRequestBody
    $AzureHeaders          = @{'Authorization'="$($oAuth.token_type) $($oAuth.access_token)"}
    #endregion Authentication


    [uri]$SignInsUrl       = https://graph.microsoft.com/v1.0/auditLogs/signIns?`$filter=userPrincipalName eq '$_'
    $SignIns               = Invoke-RestMethod -Uri $SignInsUrl.AbsoluteUri -Headers $AzureHeaders
    if($SignIns.value.Count -eq 0) {
        $InactiveUsers += $_
    }
}
$InactiveUsers 
