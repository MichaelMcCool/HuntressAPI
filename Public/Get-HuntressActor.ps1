function Get-HuntressActor {
    $URI="$($script:HuntressBaseURI)actor"
    $rawdata=New-HuntressAPIQuery -URI $URI
    $rawdata.user
}