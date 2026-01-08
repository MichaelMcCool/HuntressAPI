function Set-HuntressBaseURI {
        param (
        [Parameter(Mandatory=$false,Position=0)]
        [string]$BaseURI
    )
    
    if ([string]::IsNullOrWhiteSpace($BaseURI)) {
        $CurrentVerbose=$VerbosePreference
        $VerbosePreference='Continue'
        write-verbose "Huntress BaseURI not set. Using default value of `"https://api.huntress.io/v1/`"."
        $BaseURI="https://api.huntress.io/v1/"
        $VerbosePreference=$CurrentVerbose
    }
    # Add a trailing '/' if missing.
    if ($BaseURI[-1] -ne '/'){
        $BaseURI="$BaseURI/"
    }
    $script:HuntressBaseURI=$BaseURI
}