# Microsoft Entra ID Application Export Script

## Introduction
Efficiently managing and auditing applications within **Microsoft Entra ID** (formerly Azure AD) is crucial for security and compliance. This PowerShell script retrieves all registered applications, extracts essential details, and exports them into a structured CSV file for easy analysis.

## Features
- **Seamless Connection:** Connects to **Microsoft Graph API** with the required permissions.
- **Comprehensive Data Retrieval:** Fetches all applications registered in your Entra ID tenant.
- **Owner Identification:** Retrieves and lists assigned owners for each application (if available).
- **Structured Output:** Formats and exports the data into a **CSV file** for further review.
- **Administrator-Friendly:** Provides a straightforward way to audit and manage applications efficiently.

## Prerequisites
Before running the script, ensure that you have:
- **PowerShell** installed on your system.
- **Microsoft Graph PowerShell SDK** installed.
- The necessary permissions: `Application.Read.All`, `Directory.Read.All`.

## Installation
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/your-repository/entra-app-export.git
   cd entra-app-export
   ```
2. **Install Microsoft Graph PowerShell SDK** (if not already installed) following the best practices outlined in [this blog post](https://m365blog.com/set-up-microsoft-graph-powershell-best-practice-implementation/?preview_id=203&preview_nonce=f740fbcecc&preview=true&_thumbnail_id=207).

## Usage
### Step 1: Connect to Microsoft Graph
```powershell
Connect-MgGraph -Scopes "Application.Read.All", "Directory.Read.All"
```

### Step 2: Run the Script
```powershell
.\EntraAppsExport.ps1
```

### Step 3: Retrieve Output
After execution, a **CSV file** (`Entra_Applications.csv`) will be generated in the script's directory, containing the extracted data.

## Output Details
The CSV file includes the following columns:
- **Application Name**: The display name of the registered application.
- **Application ID**: The unique identifier assigned to the application.
- **Created Date**: The date when the application was created.
- **Owners**: List of owners assigned to the application (if applicable).

## Troubleshooting
- **Permission Issues?** Ensure your user has the necessary Microsoft Graph API permissions.
- **Execution Policy Restrictions?** Run the following command to allow script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```
- **No Applications Found?** Verify your access rights and check if applications exist in your Entra ID tenant.

## License
This script is **open-source** and available under the **MIT License**.

## Author
[Your Name] - Read more on [Your Blog/Website]
