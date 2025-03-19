# Import Active Directory module
Import-Module ActiveDirectory

# Define the group properties
$groupName = "DL_Corp_IT_Infrastructure"
$groupDescription = "Distribution list for Corporate IT Infrastructure team under Alan"
$ouPath = "OU=Managed,OU=RBAC,DC=corp,DC=gianteagle,DC=com"

# Define the members list
$members = @("Knepshield, Robie", "Bertovich, Thomas", "Petro, Mark", "Kalmar, Brian", "Berner, Ron", "Fischer, Jon", 
             "Urso, James", "McGee, Joseph", "Szalla, Jessica", "Hudson, John", "Ketterer, Mary Lynn", "Wright, Adam", 
             "Martin, Shannon", "Cumpston, Aaron", "Virostek, Christopher", "Shellhammer, Jacent", "Lersch, James", 
             "Sivak, Arlo", "Bellini, Joseph", "Quiring, Jeffrey", "Stipetich, Joey", "Costantini, Rick", 
             "Dimsho, Melissa", "Ham, Christopher", "Stephen.Aveard@gianteagle.com", "Sharrer, John", 
             "Rinier, Randal", "Moffat, Steve", "Paprocki, Michael", "King, Tom", "Wagner, Philip", "Domaracki, Charles", 
             "Charleson, Brian", "Wright, Brian", "Phelan, Daniel", "Cunningham, Denaye", "Mayiras, Ilona", 
             "Weathers, Robert", "Runyan, Ina", "Manchini, David", "Steidl, John", "Carroll, Chris", "Harms, Damien", 
             "Soehl, Stephen", "Shepler, John", "Devine, John", "Defibaugh, Matthew", "Gray, Jason", "Liberatore, Ross", 
             "Williams, Donald", "Miller, Dalton", "Phillips, William", "Woolum, Michelle", "Miller, Andrew", 
             "Oblinger, Noah", "Murdoch, Mark", "Edinger, Sean", "Conceicao, Wade", "Malek, MaryCatherine", 
             "Wittmer, James", "Brown, Jacqueline", "Badic, Damir", "Fischer, Jordan", "Jones, Nathanael", 
             "Hagens, Michael", "Whitehead, Kerri", "Weber, Joseph", "Weber, Chet", "Wells, Andrew", 
             "Dennise.VolpeWeber@gianteagle.com", "Alexander, Matthew", "Vason, Melvin", "Chase, Chance", 
             "Alex.Evans2@gianteagle.com", "Strunk, Stephan", "Gambellin, Jessie", "Tristan.Smyth@gianteagle.com", 
             "Kovacs, Daniel", "Dylan.Wright3@gianteagle.com", "Dasari, Prasad", "Allamsetty, Ramakoteswararao", 
             "S, Sukanya", "Khandai, Ansuman", "Jagan, Manoj Kumar", "Protich, Michael", "Bir, Amit", "Kumar, Gulshan", 
             "Mule, Ravindra Reddy", "Savalagi, Aneelkumar", "Bellapu, Aashish", "Patil, Anroop", "Irfan, Mohammed", 
             "Shalamath, Prashanth", "Jobst, Herb", "K, Naresh", "Khan, Muzahad", "Zager, Louis", "Kumar, Dipesh", 
             "Hoffman, Ronald", "Awadhiya, Ayushi", "Ritchey, Eric", "Atwood, Matthew", "Wynn, Tyler", "Kundula, Venkat", 
             "Kumari, Minu", "Mollera, Shyni", "Chang, Justin", "Hakim, Michael", "Carryer, Richard", "Sullivan, Marc", 
             "Finale, Anika", "Mendez, Alex", "Marella, Venu", "Sheikh, Hassan", "Farez, Omar", "Valentine, Darrell", 
             "Swanagin, Phil", "Rayford, Wynton", "Sharma, Arjun", "Cha, Wengel", "Panchal, Mahesh", "Procopio, Marc", 
             "Franks, Tyler", "K, Bhushan", "Votour, Paul", "M, Saifur Rahmaan", "Das, Anwesha", 
             "Arangottukara Krishnan, Kaushik", "Kane, Zach", "Pandey, Shreya", "Sutton, Barry", 
             "Jayaraman, Jagadeeshwaran", "Kumar, Pranav", "Brandt, Holly", "Brantner, James", "Kendall, Scott", 
             "Johnson, Willie", "Fall, Herbert", "Priyadharshini, Sam", "Martin, James", "Kazi, Najamuddin", 
             "Zanati, Mohamed", "Denny, Steve", "Battan, Greg", "Brecker, Carl", "Thompson, Stephen", "Shepard, Brian", 
             "Kamis, Brian", "Muncie, Robert", "Nelson, Michael", "Kean, Pat", "Price, Caitlin", "Treichler, Gus", 
             "Butler, Jim", "Dowden, Brian", "Peoples, Bryan", "Pinson, Tyler", "Chawla, Sonam", "Lippert, Alan")

# Create the distribution group in Active Directory
New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Distribution -Path $ouPath -Description $groupDescription

# Check if the group creation was successful
$adGroup = Get-ADGroup -Filter { Name -eq $groupName }

if ($adGroup) {
    Write-Host "AD Group '$groupName' created successfully in '$ouPath'."

    # Mail enable the group (if Exchange Online or On-premises is set up)
    # Uncomment the following lines if using Exchange Online
    # Connect to Exchange Online (if required)
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline

    # Enable the AD group for mail
    Enable-DistributionGroup -Identity $groupName
    Write-Host "Mail-enabled AD Group '$groupName' created successfully."

    # Loop through each member and add them to the group
    foreach ($member in $members) {
        try {
            # Assuming members are AD users or contacts that exist in AD
            Add-ADGroupMember -Identity $groupName -Members $member -ErrorAction Stop
            Write-Host "Added member: $member to group: $groupName"
        }
        catch {
            Write-Host "Failed to add member: $member to group: $groupName. Error: $_"
        }
    }
} else {
    Write-Host "Failed to create AD Group '$groupName'."
}
