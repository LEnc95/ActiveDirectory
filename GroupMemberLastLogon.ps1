$Members = Get-ADGroupMember IS
$results
#$Member.SamAccountName
foreach($Member in $Members){
$lastlogonDate = Get-ADUser $Member -Properties * | select LastLogonDate
$samaccountname = $Member.SamAccountName
Write-Host "$($samaccountname) last logon date was $($lastlogonDate)"
$results = "$($samaccountname) last logon date was $($lastlogonDate)"
}
$results | Export-Csv -Path ".\Documents\GitHub\Reports\IS_LastLogonDate_2020-07-02.csv"

# Import-Csv .\Documents\GitHub\Reports\IS_2020-07-02.csv | ForEach-Object {
    #Get-ADUser -Identity $($_.EmployeeID) -Properties “LastLogonDate”
#    Write-Host "$($_.Name), whose Employee ID is $($_.SamAccountName),last logon date was $($_.LastLogonDate)."
#}
<#
Import-Module ActiveDirectory
 
function Get-ADUsersLastLogon()
{
  $dcs = Get-ADDomainController -Filter {Name -like "*"}
  $users = Import-Csv .\Documents\GitHub\Reports\IS_2020-07-02.csv
  $time = 0
  $importFilePath = ".\Documents\GitHub\Reports\IS_2020-07-02.csv"
  $exportFilePath = ".\Documents\GitHub\Reports\lastlogon.csv"
  $columns = "name,username,datetime"

  Out-File -filepath $exportFilePath -force -InputObject $columns

  foreach($user in $users)
  {
    foreach($dc in $dcs)
    { 
      $hostname = $dc.HostName
      $currentUser = Get-ADUser $user.SamAccountName | Get-ADObject -Server $hostname -Properties lastLogon

      if($currentUser.LastLogon -gt $time) 
      {
        $time = $currentUser.LastLogon
      }
    }

    $dt = [DateTime]::FromFileTime($time)
    $row = $user.Name+","+$user.SamAccountName+","+$dt

    Out-File -filepath $exportFilePath -append -noclobber -InputObject $row

    $time = 0
  }
}
 
Get-ADUsersLastLogon
#>