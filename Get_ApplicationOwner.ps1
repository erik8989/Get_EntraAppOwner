<#
.SYNOPSIS
    Extracts and exports Microsoft Entra ID applications and their owners.

.DESCRIPTION
    This PowerShell script connects to Microsoft Graph API and retrieves all registered applications
    within Microsoft Entra ID. It collects application details, including name, ID, creation date,
    and associated owners. The results are then exported to a CSV file for auditing purposes.

.AUTHOR
    Erik Hüttmeyer - Published on m365blog.com

.NOTES
    - Requires Microsoft Graph PowerShell SDK.
    - Ensure the necessary permissions are granted: Application.Read.All, Directory.Read.All.

#>

# Connect to Microsoft Graph with necessary permissions
Connect-MgGraph -Scopes "Application.Read.All", "Directory.Read.All"

# Function to retrieve all applications in Microsoft Entra ID
function Get-AllMgApplications {
    $uri = "https://graph.microsoft.com/v1.0/applications"  # Microsoft Graph API endpoint
    $applications = @()  # Initialize an empty array to store applications

    do {
        # Send a GET request to fetch application data
        $response = Invoke-MgGraphRequest -Uri $uri -Method GET
        $applications += $response.value  # Append retrieved applications to the array
        $uri = $response.'@odata.nextLink'  # Get the next page of results, if available
    } while ($uri)  # Loop until there are no more pages

    return $applications  # Return the collected application data
}

# Retrieve all applications
$applications = Get-AllMgApplications
Write-Host "Number of applications found: $($applications.Count)"

# Initialize an array to store application details
$results = @()

# Loop through each application
foreach ($app in $applications) {
    # Retrieve application owners
    $owners = Get-MgApplicationOwner -ApplicationId $app.id

    # Initialize an empty list for owner details
    $ownersList = @()
    if ($owners) {
        foreach ($owner in $owners) {
            $displayName = $owner.AdditionalProperties["displayName"] -as [string]
            $userPrincipalName = $owner.AdditionalProperties["userPrincipalName"] -as [string]

            # Handle cases where display name or user principal name is missing
            if (-not $displayName) { $displayName = "Unknown Owner" }
            if (-not $userPrincipalName) { $userPrincipalName = "N/A" }

            # Append formatted owner information
            $ownersList += "$displayName ($userPrincipalName)"
        }
    } else {
        $ownersList = "No Owner Assigned"  # Indicate if no owner is assigned
    }

    # Store application details in a custom PowerShell object
    $results += [PSCustomObject]@{
        "Application Name" = $app.displayName
        "Application ID"   = $app.appId
        "Created Date"     = $app.createdDateTime
        "Owners"           = ($ownersList -join "; ")  # Join multiple owners with a semicolon
    }
}

# Define the CSV output file path
$csvPath = "$PSScriptRoot\Entra_Applications.csv"

# Export the results to a CSV file
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Confirm file creation
Write-Host "CSV successfully created: $csvPath"

# Blog Reference
Write-Host "Script by Erik Hüttmeyer - Read more on m365blog.com"