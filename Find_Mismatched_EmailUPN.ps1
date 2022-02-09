<#$users = (
    "1140219",
    "1314474",
    "1316314",
    "1110252",
    #"1007683", Bad ID provided
    "1007638",
    "2025022",
    "1050514"
)
$users | ForEach-Object {
    Get-aduser $_ -Properties EmailAddress, UserPrincipalName, employeeid | Select-Object EmailAddress, UserPrincipalName, samaccountname, employeeid
}#>
$mismatched = ""

#Get active users by OU
$OUs               = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com", "OU=Corporate Users,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"
#$LookBack_Date     = Get-Date (Get-Date).AddDays(-90) -Format 'yyyyMMdd000000.0Z'                         # LDAP DateTime for Creation Date
#$LookBack_FileTime = (Get-Date).AddDays(-90).ToFileTime()                                                 # FileTime for Password and LastLogon
$LDAP_Lookup       = '(&'                                                                                 # Define LDAP as a AND across all filters
$LDAP_Lookup      += '(objectCategory=person)'                                                            # LDAP Person
$LDAP_Lookup      += '(objectClass=user)'                                                                 # LDAP User
$LDAP_Lookup      += '(!userAccountControl:1.2.840.113556.1.4.803:=2)'                                    # LDAP Enabled
#$LDAP_Lookup      += '(!memberOf=CN=SG_Expired_Accounts,OU=Security Groups,DC=corp,DC=gianteagle,DC=com)' # LDAP Not a member of Expired Group
#$LDAP_Lookup      += "(pwdLastSet<=$LookBack_FileTime)"                                                   # LDAP Password Set over 90 Days Ago
#$LDAP_Lookup      += "(whenCreated<=$LookBack_Date)"                                                      # LDAP Created over 90 Days Ago
$LDAP_Lookup      += ')'                                                                                  # Close LDAP
foreach($OU in $OUs) {
    $users += Get-ADUser -LDAPFilter $LDAP_Lookup -SearchBase $OU -Property EmailAddress, UserPrincipalName, DisplayName, SamAccountName
} 

#$users = Get-aduser -Filter *  -SearchBase $OU -Properties EmailAddress <#| Select-Object -First 100#>
$mismatched = $users | Select-Object <#-First 100#> EmailAddress, UserPrincipalName, DisplayName, SamAccountName | Where-Object {$_.UserPrincipalName -NE $_.EmailAddress -and $_.EmailAddress -NE $NULL}
$mismatched | Export-Csv -Path "C:\Temp\mismatchedUPN_2-1-2022.csv"