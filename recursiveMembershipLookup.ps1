$UsersOutFile = "C:\Temp\$user.csv" 
do {
    $searchType = Read-Host "[1]Search by Group [2]Search by User"
    if ($searchType -eq "1") {
        Write-Host "Search by Group"
        $group = Read-Host "Group Display Name"
        $groupData = Get-ADGroup $group -Properties members | Select-Object -ExpandProperty members | ForEach-Object { Get-ADUser $_ -Properties * } | Select-Object givenname, surname, SamAccountName, extensionAttribute13, title, @{name = 'lastlogontimestamp'; expression = { [DateTime]::FromFileTime($_.lastlogontimestamp) } }, @{name = 'membership'; expression = { $_.memberof -join ',' } }
        $groupData
        $export = Read-Host "Export to csv? [1]YES/[2]no"
        if (1 -eq $export) {
            $GroupsOutFile = "C:\Temp\$group.csv"
            $groupData | Export-Csv -Path $GroupsOutFile
            Write-Host "File has been saved to $GroupsOutFile" -ForegroundColor Green
        }<#if (2 -eq $export) {
            Write-Host "Nothing has been exported"
        }
        else {
            Write-Host "Invalid entry. Skipping export" -ForegroundColor Yellow
        }#>
    }if ($searchType -eq "2") {
        Write-Host "Search by User"
        $user = Read-Host "User SamAccountName"
        $UserData = Get-ADUser $user -Properties * | Select-Object givenname, surname, SamAccountName, extensionAttribute13, title,  @{name = 'lastlogontimestamp'; expression = { [DateTime]::FromFileTime($_.lastlogontimestamp) } }, @{name = 'membership'; expression = { $_.memberof -join ',' } }
        $UserData
        $export = Read-Host "Export to csv? [1]YES/[2]no"
        if (1 -eq $export) {
            $UsersOutFile = "C:\Temp\$user.csv"
            $UserData | Export-Csv -Path $UsersOutFile
            Write-Host "File has been saved to $UsersOutFile" -ForegroundColor Green
        }<#if (2 -eq $export) {
            Write-Host "Nothing has been exported"
        }
        else {
            Write-Host "Invalid entry. Skipping export" -ForegroundColor Yellow
        }#>
    }
    else {
        #Write-Host "Invalid search type" -ForegroundColor Red
    }
} while ($true)
