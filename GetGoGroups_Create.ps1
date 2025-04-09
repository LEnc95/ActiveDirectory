# Define the nonbanner_stores group
$nonBannerGroup = "nonbanner_stores"

# Define the list of common supermarket foods
$foodList = @(
    "Banana", "Apple", "Milk", "Bread", "Orange", "Carrot", "Cucumber", "Eggplant", "Lettuce", "Tomato",
    "Potato", "Onion", "Cheese", "Butter", "Chicken", "Beef", "Pork", "Fish", "Rice", "Pasta",
    "Cereal", "Yogurt", "Juice", "Coffee", "Tea", "Spinach", "Peach", "Strawberry", "Watermelon", "Grapes",
    "Pepper", "Garlic", "Cabbage", "Zucchini", "Cantaloupe", "Melon", "Papaya", "Mango", "Lemon", "Lime"
)

# Function to generate random password (at least 8 characters)
function Generate-RandomPassword {
    $food = Get-Random -InputObject $foodList
    $number = Get-Random -Minimum 10 -Maximum 99
    $password = "$food$number!"

    # Ensure the password is at least 8 characters
    if ($password.Length -lt 8) {
        $password += "!"  # Append a second "!" to meet length requirement if necessary
    }

    return $password  # Return the plain-text password
}

# Ensure the directory exists
$directory = "C:\temp"
if (-not (Test-Path -Path $directory)) {
    New-Item -Path $directory -ItemType Directory
}

# Path to the CSV file for logging credentials
$csvFilePath = "$directory\user_credentials.csv"

# Prepare a list to hold the user data
$userData = @()

# List of site IDs and descriptions
$siteData =  @(
    @{SiteID = 3070; Description = "3070 Donaldson Crossroads GetGo PA"},
    @{SiteID = 3386; Description = "3386 Butler Road GetGo PA"},
    @{SiteID = 3392; Description = "3392 Akron Route 224 & 241 GG OH"}
)


# Loop through each site and process it
foreach ($site in $siteData) {
    $siteID = $site.SiteID
    $storeDescription = $site.Description

    try {
        # Generate a random password for resetting
        $newPassword = Generate-RandomPassword

        # Create the user object with the format 'GetGo <SiteID>'
        $userName = "GetGo$siteID"

        # Check if the user exists in Active Directory
        $existingUser = Get-ADUser -Filter {SamAccountName -eq $userName}

        if ($existingUser) {
            Write-Host "User $userName already exists. Skipping user creation."
        } else {
            # Create the AD user since it doesn't exist
            New-ADUser -SamAccountName $userName -UserPrincipalName "$userName@redbaron.com" -Name $userName `
                       -GivenName "GetGo" -Surname "$siteID" -DisplayName "$storeDescription" `
                       -Path "CN=Users,DC=redbaron,DC=com" -AccountPassword (ConvertTo-SecureString $newPassword -AsPlainText -Force) `
                       -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true

            Write-Host "Created new user: $userName with password: $newPassword"
        }

        # Add the user to the nonbanner_stores group
        Add-ADGroupMember -Identity $nonBannerGroup -Members $userName

        # Log the username and new password (plain-text) in the userData array
        $userData += [PSCustomObject]@{
            Username = $userName
            Password = $newPassword  # Log plain-text password
        }

    } catch {
        Write-Host "Error processing user $($userName): $_"
    }
}

# Output the user data to a CSV file
if ($userData.Count -gt 0) {
    $userData | Export-Csv -Path $csvFilePath -NoTypeInformation -Force
    Write-Host "Usernames and new passwords have been saved to $csvFilePath"
} else {
    Write-Host "No users were created or updated."
}
