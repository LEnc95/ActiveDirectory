# Function Reference Guide

## Overview
This document provides detailed reference information for all functions, parameters, and return values in the Active Directory Automation Collection.

---

## Core Functions

### User Management Functions

#### CacheUserData
**File**: `ad-checkuser.ps1`
```powershell
function CacheUserData()
```
- **Purpose**: Retrieves and caches user data from Active Directory
- **Parameters**: None (uses global variable `$dks`)
- **Returns**: Void (populates global `$userdata` variable)
- **Dependencies**: ActiveDirectory module
- **Example**:
```powershell
$dks = "john.doe"
CacheUserData
```

#### GetUsersData
**File**: `ad-checkuser.ps1`
```powershell
function GetUsersData
```
- **Purpose**: Displays cached user information
- **Parameters**: None (uses global `$userdata`)
- **Returns**: Array of user properties
- **Output Properties**:
  - SamAccountName
  - DisplayName
  - EmailAddress
  - telephoneNumber
  - Company
  - Description
  - Department
- **Example**:
```powershell
CacheUserData
GetUsersData
```

#### Unlock
**File**: `ad-checkuser.ps1`
```powershell
function Unlock()
```
- **Purpose**: Detects and unlocks locked user accounts
- **Parameters**: None (uses global `$userdata` and `$dks`)
- **Returns**: Void
- **Side Effects**: Unlocks account if locked
- **Console Output**: Color-coded status messages
- **Example**:
```powershell
$dks = "locked.user"
CacheUserData
Unlock
```

#### Enable
**File**: `ad-checkuser.ps1`
```powershell
function Enable()
```
- **Purpose**: Enables disabled user accounts with confirmation
- **Parameters**: None (uses global `$userdata` and `$dks`)
- **Returns**: Void
- **Interactive**: Prompts for confirmation (Y/n)
- **Side Effects**: Enables account if confirmed
- **Example**:
```powershell
$dks = "disabled.user"
CacheUserData
Enable
```

#### ResetPassword
**File**: `ad-checkuser.ps1`
```powershell
function ResetPassword()
```
- **Purpose**: Resets user password with interactive prompts
- **Parameters**: None (uses global `$dks`)
- **Returns**: Void
- **Interactive**: Prompts for new password
- **Security**: Forces password change at next logon
- **Example**:
```powershell
$dks = "user.needsreset"
ResetPassword
```

---

### Group Management Functions

#### Get-Reports
**File**: `ADorgChart.ps1`
```powershell
Function Get-Reports($ReportDN, $ManagerDN, $ManagerName, $Offset)
```
- **Purpose**: Generates organizational chart reports
- **Parameters**:
  - `$ReportDN` (string): Distinguished name of report
  - `$ManagerDN` (string): Manager's distinguished name
  - `$ManagerName` (string): Manager's display name
  - `$Offset` (int): Indentation level for hierarchy
- **Returns**: Formatted organizational structure
- **Example**:
```powershell
Get-Reports "CN=John Doe,OU=Users,DC=corp,DC=domain,DC=com" "CN=Jane Manager,OU=Users,DC=corp,DC=domain,DC=com" "Jane Manager" 0
```

#### Get-BasgThysecGroups
**File**: `Audit_BASG_THYSEC_membership.ps1`
```powershell
function Get-BasgThysecGroups {
    param (
        [string]$UserSamAccountName
    )
}
```
- **Purpose**: Audits BASG and THYSEC group memberships
- **Parameters**:
  - `$UserSamAccountName` (string): User's SAM account name
- **Returns**: Group membership information
- **Example**:
```powershell
Get-BasgThysecGroups -UserSamAccountName "john.doe"
```

---

### Reporting Functions

#### Export-ADUserDataToHTML
**File**: `ReportingCenter/func.ps1`
```powershell
function Export-ADUserDataToHTML {
    param($who)
}
```
- **Purpose**: Exports user data to HTML format
- **Parameters**:
  - `$who` (string): User identifier (account name, display name, or UPN)
- **Returns**: Void
- **Output**: HTML file in `html/userReports/$who.html`
- **Data Included**:
  - Name
  - Enabled status
  - Password expiration status
  - Password last set date
- **Example**:
```powershell
Export-ADUserDataToHTML -who "john.doe"
Export-ADUserDataToHTML -who "John Doe"
Export-ADUserDataToHTML -who "john.doe@company.com"
```

#### Get-ADUsersLastLogon
**File**: `GroupMemberLastLogon.ps1`
```powershell
function Get-ADUsersLastLogon()
```
- **Purpose**: Retrieves last logon information for group members
- **Parameters**: None (uses script-level variables)
- **Returns**: User objects with last logon timestamps
- **Features**:
  - Converts file time to readable format
  - Handles multiple domain controllers
  - Sorts by last logon date
- **Example**:
```powershell
Get-ADUsersLastLogon
```

---

### Azure Integration Functions

#### AzureConnect
**File**: `CheckUser.ps1`
```powershell
Function AzureConnect {
    # Connection logic
}
```
- **Purpose**: Establishes connection to Azure AD
- **Parameters**: None
- **Returns**: Azure AD connection object
- **Dependencies**: AzureAD module
- **Example**:
```powershell
AzureConnect
```

#### AzureGetUser
**File**: `CheckUser.ps1`
```powershell
Function AzureGetUser {
    # User retrieval logic
}
```
- **Purpose**: Retrieves user information from Azure AD
- **Parameters**: None (uses script context)
- **Returns**: Azure AD user object
- **Example**:
```powershell
AzureConnect
AzureGetUser
```

#### ADuser
**File**: `CheckUser.ps1`
```powershell
Function ADuser {
    # AD user retrieval logic
}
```
- **Purpose**: Retrieves user information from on-premises AD
- **Parameters**: None (uses script context)
- **Returns**: AD user object
- **Example**:
```powershell
ADuser
```

---

### Utility Functions

#### Generate-RandomPassword
**File**: `GetGoGroups_Create.ps1`
```powershell
function Generate-RandomPassword {
    # Password generation logic
}
```
- **Purpose**: Generates secure random passwords
- **Parameters**: None
- **Returns**: String (plain-text password)
- **Format**: `[FoodName][RandomNumber]!`
- **Requirements**:
  - Minimum 8 characters
  - Contains uppercase, lowercase, number, special character
- **Example**:
```powershell
$password = Generate-RandomPassword
# Example output: "Banana42!"
```

#### getuser
**File**: `TSDHelper.ps1`
```powershell
Function getuser($who){
    # User lookup logic
}
```
- **Purpose**: Flexible user lookup function
- **Parameters**:
  - `$who` (string): User identifier
- **Returns**: User object with extended properties
- **Features**:
  - Supports multiple identifier types
  - Returns comprehensive user data
- **Example**:
```powershell
$user = getuser "john.doe"
$user = getuser "John Doe"
```

#### Get-SecretServerCredential
**File**: `Inactive user reporting.ps1`
```powershell
function Get-SecretServerCredential {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [Alias('Name')]
                  [string]$SecretName,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromRemainingArguments=$false,
                   Mandatory=$false)]
                  [string]$ParameterName
    )
}
```
- **Purpose**: Retrieves credentials from Secret Server
- **Parameters**:
  - `$SecretName` (string, optional): Name of the secret
  - `$ParameterName` (string, optional): Specific parameter to retrieve
- **Returns**: Credential object
- **Features**:
  - Pipeline support
  - Parameter aliases
  - Optional parameters
- **Example**:
```powershell
$cred = Get-SecretServerCredential -SecretName "ADServiceAccount"
$password = Get-SecretServerCredential -SecretName "ADServiceAccount" -ParameterName "Password"
```

#### peaches
**File**: `setAccountTitle.ps1`
```powershell
function peaches {
    # Account title setting logic
}
```
- **Purpose**: Sets account titles for users
- **Parameters**: None (uses script context)
- **Returns**: Void
- **Side Effects**: Updates user title attribute
- **Example**:
```powershell
peaches
```

---

## Script Entry Points

### Interactive Scripts

#### recursiveMembershipLookup.ps1
**Purpose**: Interactive group and user membership analysis
**Entry Point**: Direct execution
**User Interface**:
```
[1]Search by Group [2]Search by User
```
**Workflow**:
1. Prompts for search type
2. Requests group name or username
3. Displays membership information
4. Offers CSV export option
5. Loops until terminated

**Export Locations**:
- Groups: `C:\Temp\$group.csv`
- Users: `C:\Temp\$user.csv`

#### ad-checkuser.ps1
**Purpose**: Interactive user account management
**Entry Point**: Direct execution
**Workflow**:
1. Prompts for user identifier
2. Caches user data
3. Displays user information
4. Offers management options (unlock, enable, reset password)

---

## Configuration Parameters

### Common Variables

#### Organizational Units
```powershell
# Standard OUs used across scripts
$ContractorsOU = "OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"
$CorporateUsersOU = "OU=Corporate Users,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com"
$RBACManagedOU = "OU=Managed,OU=RBAC,DC=corp,DC=gianteagle,DC=com"
```

#### Office 365 Groups
```powershell
# License assignment groups
$O365Groups = @(
    "O365.Executive",
    "O365.Complete", 
    "O365.Standard",
    "O365.StandardPlus",
    "O365.Basic",
    "O365.BasicPlus"
)
```

#### File Paths
```powershell
# Common file paths
$TempPath = "C:\Temp\"
$OutputPath = "$env:USERPROFILE\Documents\GitHub\Reports\"
$CSVImportPath = "C:\Users\914476\Documents\WindowsPowerShell\Scripts\newusers.csv"
```

---

## Error Handling Patterns

### Try-Catch Blocks
```powershell
try {
    # AD operation
    $user = Get-ADUser $username -Properties *
}
catch {
    Write-Error "Failed to retrieve user: $($_.Exception.Message)"
    return $null
}
```

### Validation Checks
```powershell
# User existence check
if (-not $user) {
    Write-Warning "User not found: $username"
    return
}

# Group membership validation
if ($user.MemberOf -contains $groupDN) {
    Write-Host "User is already a member" -ForegroundColor Yellow
}
```

### Progress Indicators
```powershell
$totalUsers = $users.Count
for ($i = 0; $i -lt $totalUsers; $i++) {
    Write-Progress -Activity "Processing Users" -Status "User $($i+1) of $totalUsers" -PercentComplete (($i / $totalUsers) * 100)
    # Process user
}
```

---

## Return Value Formats

### User Objects
```powershell
# Standard user properties returned
@{
    SamAccountName = "john.doe"
    DisplayName = "John Doe"
    EmailAddress = "john.doe@company.com"
    Enabled = $true
    LockedOut = $false
    PasswordExpired = $false
    LastLogonDate = "2024-01-15 09:30:00"
    MemberOf = @("CN=Group1,OU=Groups,DC=corp,DC=domain,DC=com")
}
```

### Group Objects
```powershell
# Standard group properties returned
@{
    Name = "SecurityGroup1"
    DistinguishedName = "CN=SecurityGroup1,OU=Groups,DC=corp,DC=domain,DC=com"
    GroupScope = "Global"
    GroupCategory = "Security"
    Members = @("john.doe", "jane.smith")
    MemberCount = 2
}
```

### Report Objects
```powershell
# HTML report structure
@{
    Title = "User Report"
    GeneratedDate = "2024-01-15"
    FilePath = "html/userReports/john.doe.html"
    UserData = @{
        Name = "John Doe"
        Enabled = $true
        PasswordExpired = $false
        PasswordLastSet = "2024-01-01"
    }
}
```

---

*Last Updated: 2024*
*Function Reference Version: 1.0*