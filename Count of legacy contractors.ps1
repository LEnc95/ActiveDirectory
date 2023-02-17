#Count of legacy contractors
#enabled and not expired
$users = @()
$legacyUsers = @()

$OUs               = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"
$LDAP_Lookup       = '(&'                                                                                 # Define LDAP as a AND across all filters
$LDAP_Lookup      += '(objectCategory=person)'                                                            # LDAP Person
$LDAP_Lookup      += '(objectClass=user)'                                                                 # LDAP User
$LDAP_Lookup      += '(!userAccountControl:1.2.840.113556.1.4.803:=2)'                                    # LDAP Enabled
$LDAP_Lookup      += '(!memberOf=CN=SG_Expired_Accounts,OU=Security Groups,DC=corp,DC=gianteagle,DC=com)' # LDAP Not a member of Expired Group
$LDAP_Lookup      += ')'                                                                                  # Close LDAP
foreach($OU in $OUs) {
    $users += Get-ADUser -LDAPFilter $LDAP_Lookup -SearchBase $OU -Property msDS-ExternalDirectoryObjectId, UserPrincipalName, DisplayName, lastLogonDate, whenCreated  #| Where-Object { $_.DistinguishedName -notlike '*OU=Leadership,*'}
} 
$users | ForEach-Object {
    if ($_.SamAccountName.length -lt 7){
        if ($_.samaccountname -like "8*"){
            $legacyUsers += $_
        }
        if ($_.samaccountname -like "9*"){
            $legacyUsers += $_
        }
        
    }else {
        Write-Host "$_.Samaccountname Does not meet filter."
    }
    if ($_.samaccountname -like "vend*"){
        $legacyUsers += $_
    }
}
$legacyUsers | Export-Csv -Path C:\Temp\LegacyUsers2.CSV