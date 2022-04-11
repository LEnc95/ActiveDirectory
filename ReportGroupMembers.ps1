<#        
    .SYNOPSIS 
    Report AD group members from multiple groups

    .DESCRIPTION
    Report group members and the group the are a member of.
    .NOTES
    ========================================================================
         Windows PowerShell Source File 
         Created with Love
         
         NAME: ReportGroupMembership.ps1
         
         AUTHOR: Encrapera, Luke 
         DATE  : 3/22/2022
         
         COMMENT:  
         
    ==========================================================================
#>
$dt = get-date -Format MMddyyyy_hhmmss
$exportPath = "c:\temp\GroupsInfo_"+$dt+".csv"
$groups = @()
$groups += Read-Host "Group Name"
$loop = $true
do {
    $yn = Read-Host "Add a group Y/n"
    if ($yn -ieq "Y") {
        $groups += Read-Host "Group Name"
    }
    if ($yn -ieq "n") {
        $loop = $false
    }
} until ($loop -ieq $false)

foreach($Group in $Groups) { 
Get-ADGroupMember -Id $Group | select-object  @{Expression={$Group};Label="Group Name"},Name | Export-CSV $exportPath -NoTypeInformation -append
}
Write-Host "File Output: $exportPath"