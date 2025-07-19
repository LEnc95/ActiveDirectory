# Quick Reference Guide

## Most Common Operations

### User Account Management

#### Check User Status
```powershell
.\ad-checkuser.ps1
# Interactive - follow prompts
```

#### Create Contractor Accounts
```powershell
# 1. Prepare CSV with: FirstName, LastName, UserPrincipalName, ExpirationDate
# 2. Update path in script to your CSV
.\ADContractorTool.ps1
```

#### Unlock User Account
```powershell
Unlock-ADAccount -Identity "username"
# Or use the interactive tool:
.\ad-checkuser.ps1
```

### Group Management

#### Analyze Group Memberships
```powershell
.\recursiveMembershipLookup.ps1
# Choose [1] for group search or [2] for user search
```

#### Add Users to Group from CSV
```powershell
# CSV format: UserName, GroupName
.\AddUsers2GroupfromCSV.ps1
```

#### Create Distribution List
```powershell
.\Create\ DL.ps1
# Modify script for your specific group and members
```

### Reporting

#### Generate User Report
```powershell
cd ReportingCenter
.\main.ps1
# Enter username when prompted
# Output: html/userReports/username.html
```

#### Find Inactive Licensed Users
```powershell
.\Inactive\ user\ reporting.ps1
# Analyzes O365 license groups for inactive users
```

#### Export Group Members
```powershell
Get-ADGroupMember "GroupName" | Export-Csv "C:\temp\groupmembers.csv"
```

### Office 365 Integration

#### Check License Assignments
```powershell
.\MSTeamsPolicy-OfficeLicenseAssignment.ps1
```

#### Create GetGo Store Groups
```powershell
.\GetGoGroups_Create.ps1
# Generates random passwords for store accounts
```

---

## Common PowerShell AD Commands

### User Operations
```powershell
# Get user info
Get-ADUser "username" -Properties *

# Check if user is locked
Get-ADUser "username" | Select LockedOut

# Enable user account
Enable-ADAccount "username"

# Set user password
Set-ADAccountPassword "username" -Reset -NewPassword (ConvertTo-SecureString "NewPassword123!" -AsPlainText -Force)

# Force password change at next logon
Set-ADUser "username" -ChangePasswordAtLogon $true
```

### Group Operations
```powershell
# Get group members
Get-ADGroupMember "GroupName"

# Add user to group
Add-ADGroupMember "GroupName" -Members "username"

# Remove user from group
Remove-ADGroupMember "GroupName" -Members "username"

# Get user's group memberships
Get-ADUser "username" -Properties MemberOf | Select -ExpandProperty MemberOf
```

### Search Operations
```powershell
# Find users by department
Get-ADUser -Filter {Department -eq "IT"} -Properties Department

# Find disabled accounts
Get-ADUser -Filter {Enabled -eq $false}

# Find locked accounts
Search-ADAccount -LockedOut

# Find accounts with passwords expiring soon
Search-ADAccount -AccountExpiring -TimeSpan "30.00:00:00"
```

---

## File Locations & Paths

### Input Files
- Contractor CSV: `C:\Users\914476\Documents\WindowsPowerShell\Scripts\newusers.csv`
- General imports: Update paths in individual scripts

### Output Locations
- Reports: `C:\Temp\`
- HTML Reports: `ReportingCenter/html/userReports/`
- Group Reports: `ReportingCenter/html/groupReports/`
- Credentials: `C:\temp\user_credentials.csv`

### Standard OUs
- Contractors: `OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com`
- Corporate Users: `OU=Corporate Users,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com`
- RBAC Managed: `OU=Managed,OU=RBAC,DC=corp,DC=gianteagle,DC=com`

---

## Error Troubleshooting

### Common Issues
```powershell
# Module not found
Install-Module ActiveDirectory
Import-Module ActiveDirectory

# Permission denied
# Run PowerShell as Administrator
# Verify AD permissions

# Path not found
# Update file paths in scripts to match your environment

# User not found
# Verify username spelling and domain
```

### Useful Diagnostic Commands
```powershell
# Test AD connectivity
Test-ComputerSecureChannel

# Get domain info
Get-ADDomain

# Check current user's permissions
whoami /groups

# Verify module availability
Get-Module -ListAvailable | Where-Object Name -like "*ActiveDirectory*"
```

---

## CSV File Formats

### Contractor Creation (ADContractorTool.ps1)
```csv
FirstName,LastName,UserPrincipalName,ExpirationDate
John,Doe,john.doe@company.com,2024-12-31
Jane,Smith,jane.smith@company.com,2024-12-31
```

### Group Membership (AddUsers2GroupfromCSV.ps1)
```csv
UserName,GroupName
john.doe,IT_Group
jane.smith,HR_Group
```

### General User Import
```csv
SamAccountName,DisplayName,EmailAddress,Department
john.doe,John Doe,john.doe@company.com,IT
jane.smith,Jane Smith,jane.smith@company.com,HR
```

---

## Quick Security Checks

### Account Security
```powershell
# Check for accounts with non-expiring passwords
Get-ADUser -Filter {PasswordNeverExpires -eq $true} -Properties PasswordNeverExpires

# Find privileged group members
Get-ADGroupMember "Domain Admins"
Get-ADGroupMember "Enterprise Admins"

# Check for inactive service accounts
Search-ADAccount -AccountInactive -TimeSpan "90.00:00:00" -UsersOnly
```

### Group Validation
```powershell
# Find groups with no members
Get-ADGroup -Filter * | Where-Object {(Get-ADGroupMember $_).Count -eq 0}

# Check nested group memberships
Get-ADGroupMember "GroupName" -Recursive
```

---

*For complete documentation, see [API_DOCUMENTATION.md](API_DOCUMENTATION.md) and [FUNCTION_REFERENCE.md](FUNCTION_REFERENCE.md)*