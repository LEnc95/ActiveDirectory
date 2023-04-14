Get-ADGroup -Filter "GroupCategory -eq 'Security'" -Properties DistinguishedName, ManagedBy, Members, whenChanged, whenCreated, ProtectedFromAccidentalDeletion |
    Where-Object {$_.Members.count -eq 0} |
    Select-Object Samaccountname, DistinguishedName, ManagedBy, Members, whenChanged, whenCreated, ProtectedFromAccidentalDeletion |
    Export-Csv -Path C:\Temp\SG_No_Members22123.csv -NoTypeInformation