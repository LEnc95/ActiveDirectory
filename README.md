# Active Directory Automation Collection

A comprehensive collection of PowerShell scripts and tools for automating Active Directory (AD) user management, group operations, reporting, and Office 365 license management.

## 🚀 Quick Start

### Prerequisites
- PowerShell 5.1 or higher
- Active Directory PowerShell module
- Appropriate AD permissions

### Key Features
- **User Management**: Account creation, troubleshooting, and maintenance
- **Group Operations**: Membership analysis, bulk updates, and reporting
- **Office 365 Integration**: License management and Teams policy assignment
- **Reporting**: HTML reports, CSV exports, and analytics
- **Interactive Tools**: Command-line utilities with user-friendly interfaces

## 📚 Documentation

- **[Complete API Documentation](API_DOCUMENTATION.md)** - Comprehensive guide to all scripts, functions, and usage
- **[Function Reference](FUNCTION_REFERENCE.md)** - Detailed function parameters, return values, and examples

## 🛠️ Core Tools

### User Management
- `ADContractorTool.ps1` - Automated contractor account creation
- `ad-checkuser.ps1` - Interactive user troubleshooting and management

### Group Management  
- `recursiveMembershipLookup.ps1` - Interactive membership analysis
- `Create DL.ps1` - Distribution list creation with bulk membership

### Reporting
- `ReportingCenter/` - HTML-based user and group reporting module
- `Inactive user reporting.ps1` - Office 365 license usage analytics

### Office 365 Integration
- `MSTeamsPolicy-OfficeLicenseAssignment.ps1` - Teams and license management
- Various license group management scripts

## 🏃‍♂️ Quick Usage Examples

```powershell
# Interactive user troubleshooting
.\ad-checkuser.ps1

# Analyze group memberships
.\recursiveMembershipLookup.ps1

# Generate user reports
cd ReportingCenter
.\main.ps1

# Create contractor accounts from CSV
.\ADContractorTool.ps1
```

## 📞 Support

For questions or support:
- Author: Luke Encrapera  
- Email: luke.encrapera@gianteagle.com

## 📋 License

This collection is designed for enterprise Active Directory environments. Please review and test scripts in non-production environments before deployment.
