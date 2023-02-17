$Path= "C:\Temp\ComputerGroups.csv"

$Name= "Domain Controllers"

Get-ADComputer -Filter {Name -like $Name} | ForEach-Object {

    $computer= $_

    Get-ADPrincipalGroupMembership -Identity $_|

        Select-Object @{Name = 'Computer Name'; Expression =

{$computer.SamAccountName}},@{Name = 'GroupName'; Expression =

{$_.SamAccountName}},@{Name = 'Distinguished Name'; Expression =

{$_.distinguishedname}}, @{Name = 'Member'; Expression = {$computer.DNSHostName}}

}| Export-Csv -Path $Path -NoTypeInformation