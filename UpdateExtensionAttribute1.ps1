$sngroups = Get-ADgroup -filter {samaccountname -like "SN_*"} -properties *
Write-Host "Group Count is: " $sngroups.count
$sngroups | Select-Object Samaccountname, extensionAttribute1, managedby 

#Missing managedBy
$nomanager = $sngroups | where-object {$_.managedby -eq $null}
#$nomanager | Select-Object Samaccountname, extensionAttribute1, managedby 
$nomanager | Where-Object {$null -ne  $_.extensionAttribute1} | Select-Object Name, extensionAttribute1, managedby #where ext1 is set but manager is not populated. 

#No ext1
$noext1 = $sngroups | where-object {$null -eq $_.extensionAttribute1 -and $null -ne $_.managedby }
#$noext1 | Select-Object Samaccountname, extensionAttribute1, managedby 

#updates needed
$update = @([PSCustomObject]@{})
$noext1 | foreach-object {
    $update += [PSCustomObject]@{
        Name = $_.Samaccountname
        Manager = $_.managedby.split(",").split("=")[1]
    }
} 

#Update ext1 for those SN groups with ManagedBy populated.
#$update | foreach-object {
    #$_.Name
    #$($_.Manager)
 ##   Set-ADgroup -identity $_.Name -add @{"extensionattribute1"="$($_.Manager)"}
#}
    
