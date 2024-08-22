# Get the AD group setting for BASG_THYSEC_NO_FOLDER
$groupSetting = Get-ADGroup -Identity "BASG_THYSEC_NO_FOLDER"

# Create a new AD group named BASG_THYSEC_Warehouse with the same settings
New-ADGroup -Name "BASG_THYSEC_Warehouse" -GroupCategory $groupSetting.GroupCategory -GroupScope $groupSetting.GroupScope
