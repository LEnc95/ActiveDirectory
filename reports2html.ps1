<#param ( $ReportOutputPath )

Import-Module ReportHtml Get-Command -Module ReportHtml

$ReportName = "Azure VMs Report"

if (!$ReportOutputPath) { $ReportOutputPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent }

# see if we already have a session. If we don't don't re-authN if (!$AzureRMAccount.Context.Tenant) { $AzureRMAccount = Add-AzureRmAccount } [/powershell]

Building a recordset We will need a record set to work with.  I am going to take some code Barry Shilmover shared here and add resource group name as a property to or an array of VMs

[powershell] # Get arrary of VMs from ARM $RMVMs = get-azurermvm

$RMVMArray = @() ; $TotalVMs = $RMVMs.Count; $i =1

# Loop through VMs foreach ($vm in $RMVMs) { # Tracking progress Write-Progress -PercentComplete ($i / $TotalVMs * 100) -Activity "Building VM array" -CurrentOperation ($vm.Name + " in resource group " + $vm.ResourceGroupName)

# Get VM Status (for Power State) $vmStatus = Get-AzurermVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status

# Generate Array $RMVMArray += New-Object PSObject -Property @{`

# Collect Properties ResourceGroup = $vm.ResourceGroupName Name = $vm.Name; PowerState = (get-culture).TextInfo.ToTitleCase(($vmStatus.statuses)[1].code.split("/")[1]); Location = $vm.Location; Tags = $vm.Tags Size = $vm.HardwareProfile.VmSize; ImageSKU = $vm.StorageProfile.ImageReference.Sku; OSType = $vm.StorageProfile.OsDisk.OsType; OSDiskSizeGB = $vm.StorageProfile.OsDisk.DiskSizeGB; DataDiskCount = $vm.StorageProfile.DataDisks.Count; DataDisks = $vm.StorageProfile.DataDisks; } $I++ } [/powershell]
#>

$DateTime = Get-Date -f "yyyy-MM-dd"
<#
$group = Read-Host 'Paste the group name from AD ' #'DEPT_IS_SR_MGMT_PAGE'
$CSVFile = "$env:USERPROFILE\Documents\GitHub\Reports\"+$group+"_"+$DateTime+".csv" 

Get-ADGroup $group -Properties Member |
    Select-Object -Expand Member |
    Get-ADUser -Property Name, DisplayName | Export-Csv -Path $CSVFile -NoTypeInformation | Out-String -Width 10000
Write-Host $group " has been exported to " $CSVFile
#>

#$users = Get-ADUser -Filter * -Properties * | Select-Object -First 100 | select employeeid,Name,DisplayName,UserPrincipalname  | ConvertTo-Html -As Table
#$users | Out-File -FilePath "C:\Users\914476\Documents\GitHub\Reports\users.html"

#Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

#Declare Results as array. Each request will generate its own result.
$Result = @() 

#Variable declared to open report htm in browser or for attachment to SMTP mail.
$openHTMfile = "src\report.htmC:\Users\914476\Documents\GitHub\Reports\users.html"
$openHTM = Get-Content $openHTMfile -Include $openHTMfile -ErrorAction SilentlyContinue

$users = Get-ADUser -Filter * -Properties * | Select-Object -First 100 | select employeeid,Name,DisplayName,UserPrincipalname

#Check status of URLs in $URLList
Foreach($users in $scope) { 
} 

#If the urllist still has items it will continue to format each item into a table scripted in html to display the results
if($null -ne $result) 
{ 
    $Outputreport = "<HTML>
    <link href='https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO' crossorigin='anonymous'>
    <TITLE>Website Availability Report</TITLE>
        <BODY>
            <H2> Active Directory Report </H2>
            <Table class='table table-striped'>
                <THEAD>
                    <TR class=bg-secondary>
                        <TH scope='col'><B>Employee ID</B></TH>
                        <TH scope='col'><B>Name</B></TH>
                        <TH scope='col'><B>DisplayName</B></TH>
                        <TH scope='col'><B>Account Status</B></TH>
                        <TH scope='col'><B>Last Logon</B></TH
                    </TR>
                </THEAD>"
    Foreach($Entry in $Result) 
    { 
      <#  if($Entry.StatusCode -ne "200") 
        { 
            $Outputreport += "<TR class=bg-danger>" 
        } 
        else 
        { 
            $Outputreport += "<TR>" 
        } #>
        $Outputreport += "
            <TD>$($Entry.uri)</TD>
            <TD>$($Entry.StatusCode)</TD>
            <TD>$($Entry.StatusDescription)</TD>
            <TD>$($Entry.ResponseLength)</TD>
            <TD>$($Entry.timetaken)</TD>
        </TR>"
    } 
    $Outputreport += "</Table></BODY></HTML>" 
} 
### Path can be changed to represent the directory you would like to serve the report from.
$Outputreport | out-file -FilePath "C:\Users\914476\Documents\GitHub\Reports\users.html" -Force -ErrorAction SilentlyContinue
