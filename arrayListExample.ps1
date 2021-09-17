#$arrayList = @(@("Store", "MembershipRule", "ExplicitAdditions"), @(), @())
#[System.Collections.ArrayList]$arrayList=(@("Store"),@("MembershipRule"),@("ExplicitAdditions"))
#$arrayList[0][1].Add("4444")
#$arrayList[1][1] = "some filter"
#$arrayList[2][1] = "-or (userpricipalname is yatata@gianteagle.com)"



#$arrayList = @(@("Store"),@("MembershipRule"),@("ExplicitAdditions"))

#$arrayList += , (@("val1", "val2", "val3"))

#$arrayList += , (@("val1"),@("val2"),@("val3"))
#$arrayList += @("val1","val2","val3")


<#
for ($parentLoop = 0; $parentLoop -lt 3; $parentLoop++) {
    for ($childLoop = 0; $childLoop -lt 3 ; $childLoop++) {
        "The value of [$parentLoop][$childLoop] ---> " + $arrayList[$parentLoop][$childLoop]
    }
}
#>
$filterRule = ""

$arrayHash = @{
    "111" = "additions"
}

$arrayHash.Add("555","anothafilta")

$arrayHash

foreach ($entry in $arrayHash.Keys) {
    $adds+= " " +$arrayHash.Item($entry)
    $filterRule = '(department -eq "$entry")'

}
$filterRule + $adds

$adds=$null