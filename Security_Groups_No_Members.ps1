#Get-ADGroup -Filter * -Properties Members | where { $_.Members.Count -eq 0 }
$domains = Get-ADForest | select -ExpandProperty domains
$empties = @()
$oops = @()
foreach ($d in $domains) {
    $groups = get-adgroup -filter * -server $d
    foreach ($g in $groups) {
        $q = get-adgroup $g -properties members -server $d | select -expandproperty members
        If (!$?) {
            $oops += $g
            write-host $g.name
        }
        if ($q -eq $null) { $empties += $g }
    }
}
$empties | select name, distinguishedname | export-csv C:\temp\empties.csv
$oops | select name, distinguishedname | export-csv    c:\temp\oops.csv

$empties | 