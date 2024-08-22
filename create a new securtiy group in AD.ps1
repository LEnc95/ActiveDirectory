#create a new securtiy group in AD named "BASG_THYSEC_GEB_COE"
New-ADGroup -Name "BASG_THYSEC_GEB_COE" -GroupCategory Security -GroupScope Global

#get other basg groups and check their groupscope
# Get-ADGroup -Filter {Name -like "BASG*"} | Select-Object Name, GroupScope

# get the membership of "GEB_COE_QE" group and add it to "BASG_THYSEC_GEB_COE"
$members = Get-ADGroupMember -Identity "GEB_COE_QE"
foreach ($member in $members) {
    Add-ADGroupMember -Identity "BASG_THYSEC_GEB_COE" -Members $member
}

#get members of "BASG_THYSEC_GEB_COE" group
Get-ADGroupMember -Identity "BASG_THYSEC_GEB_COE" | Select-Object Name, SamAccountName

