foreach ($user in (Import-Csv C:\Users\914476\Documents\GitHub\_infile\PDL_PCDigiPassUsers.csv <#| select -ExpandProperty identity)#>))

{
Add-ADGroupMember "PDL_PCDigiPassUsers" -Members $user.userid
<#
$u = (Get-ADUser -Identity $user.userid).distinguishedName

$g = Get-ADGroupMember -Identity “PDL_PCDigiPassUsers”| select -ExpandProperty distinguishedname

If ($g -contains $u ) {

    Write-Host " $user already exists in this group"

}

Else {

   Add-ADGroupMember $group -Members $u

   Write-host " $user added to group successfully”

  }#>
   }