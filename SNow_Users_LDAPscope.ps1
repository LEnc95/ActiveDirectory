$OUs               = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com", "OU=Corporate Users,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com", "OU=Retail Users FIM,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com", "OU=MIM Managed,OU=Service Accounts,DC=corp,DC=gianteagle,DC=com", "OU=Mail Enabled,OU=Service Accounts,DC=corp,DC=gianteagle,DC=com", "OU=AadSynced,OU=Service Accounts,DC=corp,DC=gianteagle,DC=com"
$LDAP_Lookup       = '(&'                                                                                 # Define LDAP as a AND across all filters
$LDAP_Lookup      += '(objectCategory=person)'                                                            # LDAP Person
$LDAP_Lookup      += '(objectClass=user)'                                                                 # LDAP User
$LDAP_Lookup      += '(!userAccountControl:1.2.840.113556.1.4.803:=2)'                                    # LDAP Enabled
$LDAP_Lookup      += '(!memberOf=CN=SG_Expired_Accounts,OU=Security Groups,DC=corp,DC=gianteagle,DC=com)' # LDAP Not a member of Expired Group
$LDAP_Lookup      += ')'                                                                                  # Close LDAP
foreach($OU in $OUs) {
    $users += Get-ADUser -LDAPFilter $LDAP_Lookup -SearchBase $OU -Server corp.gianteagle.com -Property msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName, lastLogonDate, whenCreated, memberof  #| Where-Object { $_.DistinguishedName -notlike '*OU=Leadership,*'}
} 
#$users = $users | Where-Object { $exclusion -notcontains $_.userPrincipalName } #Trim exclusions from set
