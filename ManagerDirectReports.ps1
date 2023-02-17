$manager = "Szalla, Jessica"

$reports = get-ADUser -filter * -Properties Manager |
select Name,samaccountname, @{n="ManagerName";e={get-aduser $_.manager | 
select -ExpandProperty name}}, @{n="ManagerEmail";e={get-aduser $_.manager -properties mail | 
select -ExpandProperty mail}} 


$reports | Where-Object {$_.ManagerName -like $manager} | fl