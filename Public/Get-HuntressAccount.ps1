function Get-HuntressAccount {
    $URI="$($script:HuntressBaseURI)account"
    $rawdata=New-HuntressAPIQuery -URI $URI
    $rawdata.account

}