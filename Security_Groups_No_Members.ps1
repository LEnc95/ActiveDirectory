#Get-ADGroup -Filter * -Properties Members | where { $_.Members.Count -eq 0 }
$domains = Get-ADForest | Select-Object -ExpandProperty domains
$empties = @()
$oops = @()
foreach ($d in $domains) {
    $groups = get-adgroup -filter * -server $d
    foreach ($g in $groups) {
        $q = get-adgroup $g -properties members -server $d | Select-Object -expandproperty members
        If (!$?) {
            $oops += $g
            write-host $g.name
        }
        if ($null -eq $q) { $empties += $g }
    }
}
$empties | Select-Object name, distinguishedname | export-csv C:\temp\empties0815.csv
$oops | Select-Object name, distinguishedname | export-csv    c:\temp\oops.csv

$report = @()
$empties | foreach-object {
   $report += Get-ADGroup -Identity $_.name -Properties * | Select-Object samaccountname, description,  whenCreated, whenChanged
}
$report | export-csv -Path c:\temp\SG_report.csv
