$user = "2113262"
get-aduser -Identity $user -Properties memberof | select -ExpandProperty memberof | Get-ADGroup | select name