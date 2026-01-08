function Set-HuntressSecret {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Secret
    )
    $script:HuntressSecret=$Secret
}