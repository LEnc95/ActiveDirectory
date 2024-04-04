# func.ps1

function Export-ADUserDataToHTML {
    param($who)
    
    # Get the user data
    $userdata = Get-ADUser -Filter {accountname -eq $who -or DisplayName -like $who -or UserPrincipalName -like $who} -Properties * | Select-Object Name, Enabled, PasswordExpired, PasswordLastSet

    # Convert the user data to HTML
    $html = $userdata | ConvertTo-Html -Title "User Report" -Body "<h1>User Report for $who</h1>"

    # Define the output path
    $outputPath = "htmll/userReports/$who.html"

    # Export the HTML to a file
    Out-File -FilePath $outputPath -InputObject $html -Encoding utf8
}



