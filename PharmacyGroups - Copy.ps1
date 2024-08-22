$pharmacygroups = Get-ADGroup -Filter {Name -like '*Pharm*'}
$pharmacygroups | Export-Csv -Path C:\Users\914476\Documents\GitHub\Reports\Pharmacy_Groups.csv
