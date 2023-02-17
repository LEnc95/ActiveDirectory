<#Delete SGs#>
$infile = Import-Csv -Path C:\Temp\Empty_Groups_Delete.csv
$infile | foreach-object {
    Remove-ADGroup -Identity $_.samaccountname  -Confirm:$false
}

$infile | foreach-object {
    try {
        Get-ADGroup -Identity $_.samaccountname
    }
    catch {
       Write-Host "$($_.samaccountname) Does not exist" 
    }
}