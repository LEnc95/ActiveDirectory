# Active Directory Automation Collection - API Documentation

## Overview

This collection provides PowerShell scripts and tools for automating Active Directory (AD) user management, group operations, reporting, and Office 365 license management. The scripts are designed for enterprise environments using Active Directory Domain Services and Microsoft 365.

## Table of Contents

1. [Core Modules](#core-modules)
2. [User Management Scripts](#user-management-scripts)
3. [Group Management Scripts](#group-management-scripts)
4. [Reporting and Analytics](#reporting-and-analytics)
5. [Office 365 Integration](#office-365-integration)
6. [Utility Functions](#utility-functions)
7. [Prerequisites](#prerequisites)
8. [Installation and Setup](#installation-and-setup)
9. [Usage Examples](#usage-examples)

---

## Core Modules

### ReportingCenter Module

Central reporting module for generating HTML-based user and group reports.

#### Files:
- `ReportingCenter/main.ps1` - Main entry point
- `ReportingCenter/func.ps1` - Core functions
- `ReportingCenter/param.ps1` - Parameter configuration

#### Functions:

##### Export-ADUserDataToHTML
```powershell
function Export-ADUserDataToHTML {
    param($who)
}
```

**Purpose**: Exports Active Directory user data to HTML format

**Parameters**:
- `$who` (string): User identifier - can be account name, display name, or UPN

**Usage Example**:
```powershell
. ./ReportingCenter/func.ps1
Export-ADUserDataToHTML -who "john.doe"
```

**Output**: HTML file in `html/userReports/$who.html`

---

## User Management Scripts

### ADContractorTool.ps1

**Purpose**: Automated creation of contractor accounts in Active Directory

**Synopsis**: Imports CSV file of users for creation in AD, specifically designed for contractor account provisioning.

**Key Features**:
- Creates contractor accounts from CSV import
- Sets random passwords and employee IDs
- Places accounts in Contractors OU
- Sets expiration dates
- Marks accounts as "Ready for MIM Script"

**Usage**:
```powershell
.\ADContractorTool.ps1
```

**Required CSV Format**:
- FirstName (GivenName)
- LastName (Surname)
- UserPrincipalName
- ExpirationDate

**Configuration**:
- Target OU: `OU=Contractors,OU=Users,OU=Managed Users & Computers,DC=corp,DC=gianteagle,DC=com`
- CSV Path: `C:\Users\914476\Documents\WindowsPowerShell\Scripts\newusers.csv`

### ad-checkuser.ps1

**Purpose**: Interactive Active Directory user account management and troubleshooting

**Author**: Luke Encrapera
**Email**: Luke.Encrapera@dcsg.com

#### Functions:

##### CacheUserData
```powershell
function CacheUserData()
```
**Purpose**: Caches user data from Active Directory for subsequent operations

##### GetUsersData
```powershell
function GetUsersData
```
**Purpose**: Displays comprehensive user information
**Returns**: SamAccountName, DisplayName, EmailAddress, telephoneNumber, Company, Description, Department

##### Unlock
```powershell
function Unlock()
```
**Purpose**: Automatically unlocks locked Active Directory accounts
**Features**: 
- Detects locked accounts
- Provides visual feedback
- Automatically unlocks accounts

##### Enable
```powershell
function Enable()
```
**Purpose**: Enables disabled Active Directory accounts
**Features**:
- Interactive confirmation prompt
- Safe account activation

##### ResetPassword
```powershell
function ResetPassword()
```
**Purpose**: Resets user passwords with security prompts

**Usage Example**:
```powershell
.\ad-checkuser.ps1
# Follow interactive prompts
```

### User Account Utilities

#### setAccountTitle.ps1
```powershell
function peaches {
    # Sets account titles for users
}
```

#### setContractorEmployeeID.ps1
**Purpose**: Updates employee IDs for contractor accounts

**Usage**:
```powershell
.\setContractorEmployeeID.ps1
```

#### UpdateExtensionAttribute1.ps1
**Purpose**: Bulk updates extensionAttribute1 for user accounts

---

## Group Management Scripts

### Create DL.ps1

**Purpose**: Creates distribution lists with predefined membership

**Example Usage**:
```powershell
.\Create\ DL.ps1
```

**Features**:
- Creates distribution groups in specified OUs
- Bulk member addition
- Support for nested group structures

### Group Management Functions

#### NewADGroup.ps1
**Purpose**: Creates new security groups in Active Directory

#### batch_update_group_members.ps1
**Purpose**: Performs bulk updates to group membership

**Usage**:
```powershell
.\batch_update_group_members.ps1
```

#### AddUsers2GroupfromCSV.ps1
**Purpose**: Adds users to groups based on CSV input

**Required CSV Format**:
- UserName
- GroupName

### Group Analysis Tools

#### recursiveMembershipLookup.ps1

**Purpose**: Interactive tool for analyzing group and user memberships

**Features**:
- Search by group or user
- Recursive membership analysis
- Export capabilities
- Last logon timestamp analysis

**Usage**:
```powershell
.\recursiveMembershipLookup.ps1
```

**Interactive Options**:
1. Search by Group - Shows all group members with details
2. Search by User - Shows user's group memberships

**Export Locations**:
- Groups: `C:\Temp\$group.csv`
- Users: `C:\Temp\$user.csv`

---

## Reporting and Analytics

### reports2html.ps1

**Purpose**: Generates comprehensive HTML reports for various AD objects

**Features**:
- Azure VM reporting integration
- Active Directory group reports
- HTML output formatting

### Inactive User Reporting

#### Inactive user reporting.ps1

**Purpose**: Identifies and reports on inactive user accounts across Office 365 licensed groups

**Target Groups**:
- O365.Complete
- O365.Standard
- O365.StandardPlus
- O365.BasicPlus
- O365.Executive

**Target OUs**:
- Contractors OU
- Corporate Users OU

#### Functions:

##### Get-SecretServerCredential
```powershell
function Get-SecretServerCredential {
    param(
        [string]$SecretName,
        [parameter]$ParameterName
    )
}
```
**Purpose**: Retrieves credentials from Secret Server for automated operations

### Specialized Reports

#### Find_Mismatched_EmailUPN.ps1
**Purpose**: Identifies users where email addresses don't match UPNs

#### Count of legacy contractors.ps1
**Purpose**: Reports on legacy contractor accounts

#### Security_Groups_No_Members.ps1
**Purpose**: Identifies empty security groups

---

## Office 365 Integration

### MSTeamsPolicy-OfficeLicenseAssignment.ps1

**Purpose**: Manages Microsoft Teams policies and Office 365 license assignments

**Key License Groups**:
- O365.Executive
- O365.Complete
- O365.Standard
- O365.StandardPlus
- O365.Basic
- O365.BasicPlus

**Features**:
- License assignment validation
- Teams policy management
- Group membership verification

### GetGoGroups_Create.ps1

**Purpose**: Creates specialized groups for GetGo store locations

#### Functions:

##### Generate-RandomPassword
```powershell
function Generate-RandomPassword {
    # Generates secure passwords using food names + numbers
    # Minimum 8 characters
    # Format: [FoodName][Number]!
}
```

**Features**:
- Random password generation
- Store-specific group creation
- CSV credential logging

**Output**: `C:\temp\user_credentials.csv`

---

## Utility Functions

### Array and Data Processing

#### arrayListExample.ps1
**Purpose**: Demonstrates PowerShell ArrayList usage patterns

#### buildGroupCriteria.ps1
**Purpose**: Builds dynamic group membership criteria

### Administrative Tools

#### CheckUser.ps1
**Functions**:
- `AzureConnect`: Establishes Azure AD connection
- `AzureGetUser`: Retrieves user data from Azure AD
- `ADuser`: Retrieves user data from Active Directory

#### ManagerDirectReports.ps1
**Purpose**: Generates manager-direct report relationships

#### pipeAD.ps1
**Purpose**: Pipeline operations for Active Directory objects

---

## Prerequisites

### Required Modules
```powershell
# Install required PowerShell modules
Install-Module ActiveDirectory
Install-Module AzureAD
Install-Module Microsoft.Graph
Install-Module ReportHtml
```

### Required Permissions
- Active Directory administrative rights
- Office 365 Global Administrator (for license operations)
- Azure AD permissions for user management

### Environment Requirements
- PowerShell 5.1 or higher
- Windows Server with AD DS role
- Network connectivity to domain controllers
- Office 365 tenant access

---

## Installation and Setup

### 1. Clone Repository
```powershell
git clone <repository-url>
cd ActiveDirectory
```

### 2. Configure Paths
Update file paths in scripts to match your environment:

```powershell
# Common paths to configure:
$CSVPath = "C:\Users\<username>\Documents\Scripts\input.csv"
$OutputPath = "C:\Temp\"
$OU = "OU=Users,DC=corp,DC=domain,DC=com"
```

### 3. Set Execution Policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. Import Modules
```powershell
Import-Module ActiveDirectory
Import-Module AzureAD
```

---

## Usage Examples

### Creating Contractor Accounts
```powershell
# 1. Prepare CSV file with required fields
# 2. Update CSV path in ADContractorTool.ps1
# 3. Execute script
.\ADContractorTool.ps1
```

### User Account Troubleshooting
```powershell
# Interactive user management
.\ad-checkuser.ps1

# Follow prompts to:
# - Check user status
# - Unlock accounts
# - Enable accounts
# - Reset passwords
```

### Group Membership Analysis
```powershell
# Analyze group memberships
.\recursiveMembershipLookup.ps1

# Options:
# [1] Search by Group - Enter group name
# [2] Search by User - Enter username
```

### Generate User Reports
```powershell
# Generate HTML user report
cd ReportingCenter
.\main.ps1
# Enter username when prompted
```

### Office 365 License Management
```powershell
# Process license assignments
.\MSTeamsPolicy-OfficeLicenseAssignment.ps1

# Monitor inactive licensed users
.\Inactive\ user\ reporting.ps1
```

### Bulk Group Operations
```powershell
# Add users from CSV to groups
.\AddUsers2GroupfromCSV.ps1

# Update group members in batch
.\batch_update_group_members.ps1
```

---

## Error Handling and Troubleshooting

### Common Issues

1. **Module Import Errors**
   ```powershell
   # Solution: Install missing modules
   Install-Module ActiveDirectory -Force
   ```

2. **Permission Denied**
   ```powershell
   # Solution: Run as administrator or check AD permissions
   ```

3. **Path Not Found**
   ```powershell
   # Solution: Update file paths in scripts
   ```

### Logging and Monitoring

Most scripts include:
- Console output with color coding
- CSV export capabilities
- Error handling with try-catch blocks
- Progress indicators for bulk operations

---

## Security Considerations

### Password Management
- Random password generation using secure patterns
- Password complexity requirements enforced
- Secure credential storage recommendations

### Account Security
- Automatic account locking detection
- Expiration date enforcement for contractors
- Group membership validation

### Audit Trail
- All operations logged to CSV files
- HTML reports for compliance
- Change tracking through AD attributes

---

## Contributing

When contributing to this collection:

1. Follow PowerShell best practices
2. Include proper error handling
3. Document all functions with synopsis/description
4. Test with non-production accounts
5. Update this documentation for new features

---

## Support and Contact

For technical support or questions about these scripts:
- Author: Luke Encrapera
- Email: luke.encrapera@gianteagle.com

---

## Version History

- **v1.0**: Initial collection with core AD management scripts
- **v1.1**: Added Office 365 integration
- **v1.2**: Enhanced reporting capabilities
- **v1.3**: Added ReportingCenter module

---

*Last Updated: 2024*
*Documentation Version: 1.0*