function Set-HuntressKey {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Key
    )
    $script:HuntressKey=$Key
}