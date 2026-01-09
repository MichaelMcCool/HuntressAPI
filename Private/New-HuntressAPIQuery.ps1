function New-HuntressAPIQuery {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$URI
    )
    $keyerror=$false
    # Don't display progress.
    $CurrentProgress=$ProgressPreference
    $ProgressPreference='SilentlyContinue'

    # Make sure that headers are set and try to configure automatically if they are missing.
    # If config is missing. Tell the user how to fix.
    if (!($script:headers)){
        $CurrentVerbose=$VerbosePreference
        $VerbosePreference='Continue'
        if (!($script:HuntressKey)){
            write-verbose "ERROR: Huntress API Key not set. Use `"Set-HuntressKey '<API Key>'`" to configure."
            $keyerror=$true
        }
        if (!($script:HuntressSecret)){
            write-verbose "ERROR: Huntress API Secret not set. Use `"Set-HuntressSecret '<API Secret>'`" to configure."
            $keyerror=$true
        }
        $VerbosePreference=$CurrentVerbose
        if ($keyerror){
            throw "Huntress API/Secret not set."
        }
        $text="$($script:HuntressKey):$($script:HuntressSecret)"
        $EncodedText=[System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($text))
        $script:Headers= @{
            Authorization="Basic $EncodedText"
        }
    }
    
    # Fix URI if HuntressBaseURI was not set.
    if ([string]::IsNullOrWhiteSpace($script:HuntressBaseURI)){
        Set-HuntressBaseURI
        $URI="$($script:HuntressBaseURI)$URI"
    }

    # Perform query against API.
    write-verbose "Querying $URI"
    $response = Invoke-WebRequest -Uri $URI -Method GET -headers $script:headers -UseBasicParsing
    switch ($response.StatusCode){
        200 {
            $response.content | ConvertFrom-Json
        }
        400 {
            # Unexpected error
            throw "400"
        }
        401 {
            # Authentication failed
            throw "401"
        }
        404 {
            # Resource unavailable
            throw "404"
        }
        409 {
            # Escalation Resolution - already resolved
        }
        422 {
            # Escalation Resolution - cannot be resolved via API
        }
        429 {
            # Rate limit
            $CurrentVerbose=$VerbosePreference
            $VerbosePreference='Continue'
            write-verbose "API rate limit exceeeded. Retrying in 10 seconds..."
            $retry=$true
            $retries=0
            do{
                start-sleep 10
                $retries++
                $response = Invoke-WebRequest -Uri $URI -Method GET -headers $script:headers -UseBasicParsing
                if ($response.Statuscode -eq 200){
                    $retry=$false
                    $response.content | ConvertFrom-Json
                }
                
                if ($retries -gt 3){
                    $retry=$false
                    write-verbose "Max retry count exceeded.. Aborting."
                }
            }
            while ($retry -eq $true)
            $VerbosePreference=$CurrentVerbose
        }
        500 {
            # Server error
            throw "500"
        }
    }

    # restore progresspreference
    $ProgressPreference=$CurrentProgress
}