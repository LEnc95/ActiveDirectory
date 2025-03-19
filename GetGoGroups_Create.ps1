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

    # Convert password to SecureString
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    return $securePassword
}

# Full list of site IDs and descriptions (7000 and 7500 series)
$siteData = @(
    @{SiteID = 7000; Description = "7000 Ricker Wholesale Admin IN"},
    @{SiteID = 7001; Description = "7001 Dealer Drop Ship Site IN"},
    @{SiteID = 7002; Description = "7002 Store Drop Ship Site IN"},
    @{SiteID = 7003; Description = "7003 Adams-Warrendale RD GetGo PA"},
    @{SiteID = 7004; Description = "7004 Broadway IN"},
    @{SiteID = 7005; Description = "7005 Frankton IN"},
    @{SiteID = 7006; Description = "7006 Middletown IN"},
    @{SiteID = 7007; Description = "7007 Lapel IN"},
    @{SiteID = 7008; Description = "7008 Elwood IN"},
    @{SiteID = 7009; Description = "7009 I69 IN"},
    @{SiteID = 7010; Description = "7010 Madison Avenue IN"},
    @{SiteID = 7011; Description = "7011 Exit 10 IN"},
    @{SiteID = 7012; Description = "7012 Applewood IN"},
    @{SiteID = 7013; Description = "7013 Alexandria - IN"},
    @{SiteID = 7014; Description = "7014 Chesterfield IN"},
    @{SiteID = 7015; Description = "7015 Tipton IN"},
    @{SiteID = 7016; Description = "7016 Meadowbrook IN"},
    @{SiteID = 7017; Description = "7017 Ninth Street IN"},
    @{SiteID = 7018; Description = "7018 Ogilville IN"},
    @{SiteID = 7019; Description = "7019 Edinburgh IN"},
    @{SiteID = 7020; Description = "7020 Edgewood IN"},
    
    # 7500 Series Sites (additional ones you provided)
    @{SiteID = 7502; Description = "7502 Broadway IN"},
    @{SiteID = 7508; Description = "7508 Frankton IN"},
    @{SiteID = 7504; Description = "7504 Middletown IN"},
    @{SiteID = 7505; Description = "7505 Lapel IN"},
    @{SiteID = 7506; Description = "7506 Elwood IN"},
    @{SiteID = 7507; Description = "7507 I69 IN"},
    @{SiteID = 7509; Description = "7509 Madison Avenue IN"},
    @{SiteID = 7510; Description = "7510 Exit 10 IN"},
    @{SiteID = 7511; Description = "7511 Applewood IN"},
    @{SiteID = 7512; Description = "7512 Alexandria - IN"},
    @{SiteID = 7514; Description = "7514 Chesterfield IN"},
    @{SiteID = 7516; Description = "7516 Tipton IN"},
    @{SiteID = 7517; Description = "7517 Meadowbrook IN"},
    @{SiteID = 7518; Description = "7518 Ninth Street IN"},
    @{SiteID = 7519; Description = "7519 Ogilville IN"},
    @{SiteID = 7520; Description = "7520 Edinburgh IN"},
    @{SiteID = 7521; Description = "7521 Edgewood IN"},
    @{SiteID = 7522; Description = "7522 The Point IN"},
    @{SiteID = 7523; Description = "7523 Downtown IN"},
    @{SiteID = 7524; Description = "7524 Exit 14 IN"},
    @{SiteID = 7525; Description = "7525 Scatterfield Rd IN"},
    @{SiteID = 7526; Description = "7526 Park One IN"},
    @{SiteID = 7528; Description = "7528 Columbus 25th Street IN"},
    @{SiteID = 7529; Description = "7529 New Palestine IN"},
    @{SiteID = 7530; Description = "7530 Post Road IN - CLOSED"},
    @{SiteID = 7531; Description = "7531 Keystone IN"},
    @{SiteID = 7533; Description = "7533 Greenwood IN"},
    @{SiteID = 7534; Description = "7534 Fort Benjamin IN"},
    @{SiteID = 7535; Description = "7535 Brownsburg IN"},
    @{SiteID = 7536; Description = "7536 South Meridian IN"},
    @{SiteID = 7537; Description = "7537 Plainfield & I-70 IN"},
    @{SiteID = 7538; Description = "7538 71st Street IN"},
    @{SiteID = 7539; Description = "7539 Mooresville IN"},
    @{SiteID = 7540; Description = "7540 Avon IN"},
    @{SiteID = 7541; Description = "7541 Plainfield US 40 IN"},
    @{SiteID = 7542; Description = "7542 NW & 86th IN"},
    @{SiteID = 7544; Description = "7544 151st IN"},
    @{SiteID = 7545; Description = "7545 Whitestown IN"},
    @{SiteID = 7546; Description = "7546 Oaklandon IN"},
    @{SiteID = 7547; Description = "7547 Aronson & 96th IN"},
    @{SiteID = 7548; Description = "7548 146th & Carey IN"},
    @{SiteID = 7549; Description = "7549 146th & River Road IN"},
    @{SiteID = 7551; Description = "7551 Wheeler IN"},
    @{SiteID = 7552; Description = "7552 Leo IN"},
    @{SiteID = 7553; Description = "7553 Coldwater IN"},
    @{SiteID = 7555; Description = "7555 St Joe Road IN"},
    @{SiteID = 7558; Description = "7558 Huntertown IN"},
    @{SiteID = 7559; Description = "7559 Sheridan IN"},
    @{SiteID = 7570; Description = "7570 West 38th IN - CLOSED"},
    @{SiteID = 7571; Description = "7571 East 38th IN - CLOSED"},
    @{SiteID = 7572; Description = "7572 Georgetown IN - CLOSED"},
    @{SiteID = 7577; Description = "7577 Clover Road IN"},
    @{SiteID = 7578; Description = "7578 116th @ Fishers IN"},
    @{SiteID = 7579; Description = "7579 East Street IN"},
    @{SiteID = 7580; Description = "7580 East Washington IN"},
    @{SiteID = 7581; Description = "7581 Tibbs IN"}
)

# Ensure the directory exists
$directory = "C:\temp"
if (-not (Test-Path -Path $directory)) {
    New-Item -Path $directory -ItemType Directory
}

# Path to the CSV file
$csvFilePath = "$directory\user_credentials.csv"

# Prepare a list to hold the user data
$userData = @()

# Loop through each site and process it
foreach ($site in $siteData) {
    $siteID = $site.SiteID
    $storeDescription = $site.Description

    try {
        # Generate a random password
        $password = Generate-RandomPassword

        # Create the user object with the format 'GetGo <SiteID>'
        $userName = "GetGo$siteID"

        # Check if the user already exists
        $existingUser = Get-ADUser -Filter {SamAccountName -eq $userName}
        if ($existingUser) {
            Write-Host "User $userName already exists. Skipping creation."
            continue
        }

        # Create the AD user
        New-ADUser -SamAccountName $userName -UserPrincipalName "$userName@redbaron.com" -Name $userName `
                   -GivenName "GetGo" -Surname "$siteID" -DisplayName "$storeDescription" `
                   -Path "CN=Users,DC=redbaron,DC=com" -AccountPassword $password `
                   -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true

        # Add the user to the nonbanner_stores group
        Add-ADGroupMember -Identity $nonBannerGroup -Members $userName

        # Add the username and password to the list
        $userData += [PSCustomObject]@{
            Username = $userName
            Password = $password
        }

        Write-Host "Created user: $userName with initial password: $password"
    } catch {
        Write-Host "Error creating user $userName: $_"
    }
}

# Output the user data to a CSV file
$userData | Export-Csv -Path $csvFilePath -NoTypeInformation -Force

Write-Host "Usernames and passwords have been saved to $csvFilePath"
