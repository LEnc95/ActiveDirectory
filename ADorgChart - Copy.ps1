# Check optional parameters indicating output format.
# The default is "Text" format and output "DN" distinguished names.
$Format = "Text"
$Output = "DN"
$Abort = $False

# Code not shown to process optional parameters.
# We show the code for $Output equal to "Name".
$Output = "Name"


# Specify the output file, with the appropriate extension.
Switch ($Format)
{
    "Text" {$File = ".\ADOrganization.txt"}
}


# Setup the DirectorySearcher object.
$D = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Domain = [ADSI]"LDAP://$D"
$Searcher = New-Object System.DirectoryServices.DirectorySearcher   [1]
$Searcher.PageSize = 200   [2]
$Searcher.SearchScope = "subtree"
$Searcher.PropertiesToLoad.Add("distinguishedName") > $Null   [3]
$Searcher.PropertiesToLoad.Add("directReports") > $Null
If ($Output -eq "Name")
{
    $Searcher.PropertiesToLoad.Add("name") > $Null
    $Searcher.PropertiesToLoad.Add("sAMAccountName") > $Null
}
$Searcher.SearchRoot = "LDAP://" + $Domain.distinguishedName


# Output header lines.
If ($Format -eq "Text")
{
    "Organization: $D"  | Out-File -FilePath $File
}


# Retrieve organization hierarchy, starting from the top.
Get-Reports "Top" "" "" ""   [4]


# Code not shown to output final tag for HTML format.


# Display the output file, in the application appropriate for the file extension.
Invoke-Expression $File   [5]

Function Get-Reports($ReportDN, $ManagerDN, $ManagerName, $Offset) [6]
{

    # Recursive function to document the organization.

    # The first time this function is called it considers managers at

    # the top of the organization hierarchy. These are objects with

    # direct reports but no manager.

    If ($ReportDN -eq "Top")

    {

        # Filter on objects with no manager and at least one direct report.

        $Filter = "(&(!manager=*)(directReports=*))" [7]

    }

    Else {# Code not shown that runs when the function is called recursively.}

    # Run the query.

    $Searcher.Filter = $Filter [8]

    $Results = $Searcher.FindAll()

    If ($Results.Count -gt 0)

    {

        # Code not shown to output HTML tabs.

        ForEach ($Result In $Results) [9]

        {

            # Output the object.

            $DN = $Result.Properties.Item("distinguishedName") [10]

            If ($Output -eq "DN")

            {

                Switch ($Format)

                {

                    "Text" {$Line = "$Offset$DN"}

                }

            }

            If ($Output -eq "Name")

            {

                # Retrieve name and sAMAccountName. [11]

                $Name = $Result.Properties.Item("name")

                $NTName = $Result.Properties.Item("sAMAccountName")

                Switch ($Format)

                {

                    "Text" {$Line = "$Offset$Name ($NTName)"} [12]

                }

            }

            $Line | Out-File -FilePath $File -Append [13]

            # Retrieve any direct reports for this object.

            $Reports = $Result.Properties.Item("directReports") [14]

            If ($Reports.Count -gt 0)

            {

                # Code not shown to output HTML tags.

                ForEach ($Report In $Reports)

                {

                    # Recursively call this function for each direct report.

                    # Increase any indenting by 4 more spaces.

                    Get-Reports $Report $DN "$Name ($NTName)" "$Offset    " [15]

                }

                # Code not shown to output HTML tags.

            }

        }

        # Code not shown to output HTML tags.

    }

}