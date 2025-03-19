<#
 .AUTHOR
        Luke Encrapera
        Email: Luke.Encrapera@gianteagle.com
        Company: Giant Eagle

#>

# Define the nonbanner_stores group
$nonBannerGroup = "nonbanner_stores"

# Full list of site IDs and descriptions (including 7000 series)
$siteData = @(
    @{SiteID = 3003; Description = "3003 Southside Works GetGo PA"},
    @{SiteID = 3009; Description = "3009 Hempfield GetGo PA"},
    @{SiteID = 3010; Description = "3010 Irwin GetGo PA"},
    @{SiteID = 3019; Description = "3019 Rowan Rd GetGo PA"},
    @{SiteID = 3021; Description = "3021 McKnight Road GetGo PA"},
    @{SiteID = 3027; Description = "3027 Richeyville GetGo PA"},
    @{SiteID = 3029; Description = "3029 Springfield GetGo OH"},
    @{SiteID = 3036; Description = "3036 Portage Trail GetGo OH"},
    @{SiteID = 3038; Description = "3038 Squirrel Hill GetGo PA"},
    @{SiteID = 3039; Description = "3039 Washington GetGo PA"},
    @{SiteID = 3050; Description = "3050 Girard GetGo PA"},
    @{SiteID = 3051; Description = "3051 Belle Vernon GetGo PA"},
    @{SiteID = 3054; Description = "3054 Somerset GetGo PA"},
    @{SiteID = 3059; Description = "3059 Morgantown GetGo WV"},
    @{SiteID = 3062; Description = "3062 Rochester GetGo PA"},
    @{SiteID = 3064; Description = "3064 Baum Blvd. GetGo PA"},
    @{SiteID = 3075; Description = "3075 Community Center GetGo OH"},
    @{SiteID = 3077; Description = "3077 New Castle GetGo PA"},
    @{SiteID = 3080; Description = "3080 Brookville GetGo PA"},
    @{SiteID = 3082; Description = "3082 Latrobe GetGo PA CLOSED"},
    @{SiteID = 3086; Description = "3086 Strongsville GetGo OH"},
    @{SiteID = 3087; Description = "3087 St Marys GetGo PA"},
    @{SiteID = 3092; Description = "3092 Lyndhurst GetGo OH"},
    @{SiteID = 3105; Description = "3105 Elizabeth GetGo PA"},
    @{SiteID = 3106; Description = "3106 Wilkinsburg GetGo PA"},
    @{SiteID = 3107; Description = "3107 Lawrenceville GetGo PA"},
    @{SiteID = 3108; Description = "3108 Penn Hills GetGo PA"},
    @{SiteID = 3109; Description = "3109 East McKeesport GetGo PA"},
    @{SiteID = 3114; Description = "3114 Shenango Valley GetGo PA"},
    @{SiteID = 3116; Description = "3116 McMurray GetGo PA"},
    @{SiteID = 3122; Description = "3122 Delmont GetGo PA"},
    @{SiteID = 3124; Description = "3124 Waterloo Road GetGo OH"},
    @{SiteID = 3127; Description = "3127 Fort Couch GetGo PA"},
    @{SiteID = 3128; Description = "3128 South Park GetGo PA - Closed"},
    @{SiteID = 3129; Description = "3129 Mt. Lebanon GetGo PA"},
    @{SiteID = 3130; Description = "3130 Cochran Road GetGo PA"},
    @{SiteID = 3132; Description = "3132 Austintown GetGo OH"},
    @{SiteID = 3135; Description = "3135 Sarver GetGo PA"},
    @{SiteID = 3137; Description = "3137 Leetsdale GetGo PA"},
    @{SiteID = 3151; Description = "3151 Howland GetGo OH"},
    @{SiteID = 3152; Description = "3152 Massillon GetGo OH"},
    @{SiteID = 3154; Description = "3154 East Wylie GetGo PA- CLOSED"},
    @{SiteID = 3166; Description = "3166 Chippewa GetGo PA"},
    @{SiteID = 3172; Description = "3172 O'Hara GetGo PA"},
    @{SiteID = 3182; Description = "3182 Ellwood City GetGo PA"},
    @{SiteID = 3185; Description = "3185 Hoffman Blvd GetGo PA"},
    @{SiteID = 3199; Description = "3199 North Ridgeville GetGo OH"},
    @{SiteID = 3203; Description = "3203 Parma Heights GetGo OH"},
    @{SiteID = 3204; Description = "3204 North Royalton GetGo OH"},
    @{SiteID = 3205; Description = "3205 Carnegie Parkway GetGo PA"},
    @{SiteID = 3216; Description = "3216 Willowick GetGo OH"},
    @{SiteID = 3218; Description = "3218 City View GetGo OH"},
    @{SiteID = 3219; Description = "3219 Warren Plaza GetGo OH"},
    @{SiteID = 3220; Description = "3220 Amherst GetGo OH"},
    @{SiteID = 3224; Description = "3224 Twinsburg GetGo OH"},
    @{SiteID = 3228; Description = "3228 Solon GetGo OH"},
    @{SiteID = 3232; Description = "3232 Erie Bayfront GetGo PA"},
    @{SiteID = 3237; Description = "3237 Erie Peach St GetGo PA"},
    @{SiteID = 3238; Description = "3238 Vermilion GetGo OH"},
    @{SiteID = 3256; Description = "3256 Ligonier GetGo PA"},
    @{SiteID = 3257; Description = "3257 Robinson GetGo PA"},
    @{SiteID = 3280; Description = "3280 Shaler GetGo PA"},
    @{SiteID = 3284; Description = "3284 Avon GetGo OH"},
    @{SiteID = 3288; Description = "3288 Titusville GetGo PA"},
    @{SiteID = 3290; Description = "3290 Erie I-90 GetGo PA"},
    @{SiteID = 3297; Description = "3297 Rocky River GetGo OH"},
    @{SiteID = 3316; Description = "3316 Westlake GetGo OH"},
    @{SiteID = 3328; Description = "3328 Boardman GetGo OH"},
    @{SiteID = 3352; Description = "3352 Camp Horne GetGo PA"},
    @{SiteID = 3356; Description = "3356 Jamestown GetGo OH"},
    @{SiteID = 3357; Description = "3357 Painesville GetGo OH"},
    @{SiteID = 3359; Description = "3359 Streetsboro GetGo OH"},
    @{SiteID = 3361; Description = "3361 Ridge Road GetGo OH"},
    @{SiteID = 3364; Description = "3364 Raff Road GetGo OH"},
    @{SiteID = 3376; Description = "3376 Fairview Park GetGo OH"},
    @{SiteID = 3379; Description = "3379 Waterfront Road GetGo PA"},
    @{SiteID = 3383; Description = "3383 Chardon GetGo OH"},
    @{SiteID = 3387; Description = "3387 Canton GetGo OH"},
    @{SiteID = 3388; Description = "3388 Broadview GetGo OH"},
    @{SiteID = 3389; Description = "3389 Medina GetGo OH"},
    @{SiteID = 3396; Description = "3396 Stow GetGo OH"},
    @{SiteID = 3401; Description = "3401 Dublin GetGo OH"},
    @{SiteID = 3403; Description = "3403 Louisville GetGo OH"},
    @{SiteID = 3425; Description = "3425 West Market GetGo OH"},
    @{SiteID = 3431; Description = "3431 Lakewood GetGo OH"},
    @{SiteID = 3435; Description = "3435 Edinboro GetGo PA"},
    @{SiteID = 3438; Description = "3438 Harborcreek GetGo PA"},
    @{SiteID = 3440; Description = "3440 South Euclid GetGo OH"},
    @{SiteID = 3465; Description = "3465 Brookpark GetGo OH"},
    @{SiteID = 3484; Description = "3484 DuBois GetGo PA"},
    @{SiteID = 3487; Description = "3487 Glenshaw GetGo PA"},
    @{SiteID = 3488; Description = "3488 Babcock Blvd GetGo PA"},
    @{SiteID = 3489; Description = "3489 Allison Park GetGo PA"},
    @{SiteID = 3500; Description = "3500 Butler GetGo PA"},
    @{SiteID = 3501; Description = "3501 Gahanna GetGo OH"},
    @{SiteID = 3503; Description = "3503 Polaris GetGo OH"},
    @{SiteID = 3507; Description = "3507 Westerville GetGo OH"},
    @{SiteID = 3510; Description = "3510 Marietta GetGo OH"},
    @{SiteID = 3511; Description = "3511 Kingsdale GetGo OH"},
    @{SiteID = 3513; Description = "3513 Blacklick GetGo OH"},
    @{SiteID = 3514; Description = "3514 Pickerington GetGo OH"},
    @{SiteID = 3515; Description = "3515 Tanglewood GetGo OH"},
    @{SiteID = 3519; Description = "3519 Lincoln Village GetGo OH"},
    @{SiteID = 3523; Description = "3523 Heath GetGo OH"},
    @{SiteID = 3526; Description = "3526 Grove City GetGo OH"},
    @{SiteID = 3527; Description = "3527 Powell GetGo OH"},
    @{SiteID = 3528; Description = "3528 New Albany GetGo OH"},
    @{SiteID = 3531; Description = "3531 Britton Parkway GetGo OH"},
    @{SiteID = 3538; Description = "3538 Lancaster GetGo OH"},
    @{SiteID = 3539; Description = "3539 Grandview Yard GetGo OH"},
    @{SiteID = 3600; Description = "3600 White Oak GetGo PA"},
    @{SiteID = 3601; Description = "3601 Wadsworth GetGo OH"},
    @{SiteID = 3602; Description = "3602 Bedford GetGo PA"},
    @{SiteID = 3606; Description = "3606 Slippery Rock GetGo PA"},
    @{SiteID = 3608; Description = "3608 Indiana GetGo PA"},
    @{SiteID = 3612; Description = "3612 Goucher Street GetGo PA"},
    @{SiteID = 3616; Description = "3616 Brentwood GetGo PA"},
    @{SiteID = 3617; Description = "3617 Mentor Convenience GetGo OH"},
    @{SiteID = 3618; Description = "3618 Hartville GetGo OH"},
    @{SiteID = 3619; Description = "3619 Edgewood GetGo PA"},
    @{SiteID = 3620; Description = "3620 Green GetGo OH"},
    @{SiteID = 3621; Description = "3621 Ashtabula GetGo OH"},
    @{SiteID = 3627; Description = "3627 Geneva GetGo OH"},
    @{SiteID = 3632; Description = "3632 Calcutta GetGo OH"},
    @{SiteID = 3638; Description = "3638 Mentor GetGo OH"},
    @{SiteID = 3642; Description = "3642 Moon Township GetGo PA"},
    @{SiteID = 3646; Description = "3646 Crafton/Ingram GetGo PA"},
    @{SiteID = 3648; Description = "3648 Middlefield GetGo OH"},
    @{SiteID = 3649; Description = "3649 Altoona GetGo PA"},
    @{SiteID = 3656; Description = "3656 Barberton GetGo OH"},
    @{SiteID = 3657; Description = "3657 Tallmadge GetGo OH"},
    @{SiteID = 3658; Description = "3658 North Madison GetGo OH"},
    @{SiteID = 3659; Description = "3659 East Hills GetGo PA"},
    @{SiteID = 3661; Description = "3661 Scalp Avenue GetGo PA"},
    @{SiteID = 3664; Description = "3664 Salem GetGo OH"},
    @{SiteID = 3670; Description = "3670 Ebensburg GetGo PA"},
    @{SiteID = 3673; Description = "3673 Waynesburg GetGo PA"},
    @{SiteID = 3675; Description = "3675 Meadville GetGo PA"},
    @{SiteID = 3681; Description = "3681 Franklin GetGo PA"},
    @{SiteID = 3689; Description = "3689 Dover GetGo OH"},
    @{SiteID = 3691; Description = "3691 Gibsonia GetGo PA"},
    @{SiteID = 3694; Description = "3694 Aliquippa GetGo PA"},
    @{SiteID = 3699; Description = "3699 Uniontown GetGo PA"},
    @{SiteID = 3701; Description = "3701 Roaring Spring GetGo PA"},
    @{SiteID = 3703; Description = "3703 Fairlawn GetGo OH"},
    # Start of 7000 series (included)
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
    @{SiteID = 7020; Description = "7020 Edgewood IN"}
    # Add any additional 7000 series sites if necessary...
)

# Loop through each site and process it
foreach ($site in $siteData) {
    $siteID = $site.SiteID
    $storeDescription = $site.Description

    # Create the AD group for each store with the format 'GetGo <SiteID>'
    $groupName = "GetGo " + $siteID
    New-ADGroup -Name $groupName -GroupScope Global -Path "CN=Users,DC=redbaron,DC=com" -Description "Group for $storeDescription" -PassThru

    # Construct the DistinguishedName for the user (assuming user follows the pattern "GetGo <SiteID>")
    $userDN = "CN=GetGo $siteID,CN=Users,DC=redbaron,DC=com"

    # Check if the user exists
    $user = Get-ADUser -Filter {DistinguishedName -eq $userDN}

    if ($user) {
        # Set user properties for the store (password never expires, user cannot change the password)
        Set-ADUser -Identity $user -CannotChangePassword $true -PasswordNeverExpires $true

        # Add the user to the nonbanner_stores group
        Add-ADGroupMember -Identity $nonBannerGroup -Members $user
    } else {
        Write-Host "User $userDN not found"
    }
}
