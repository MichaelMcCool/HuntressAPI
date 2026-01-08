function Get-HuntressAgent {
    param (
        [Parameter(ParameterSetName="Device")]
        [Parameter(Mandatory=$false)]
        [int]$DeviceId,
        [Parameter(Mandatory=$false)]
        [Parameter(ParameterSetName="Global-Site")]
        [int]$OrgId,
        [Parameter(Mandatory=$false)]
        [Parameter(ParameterSetName="Global-Site")]
        [ValidateSet("windows","darwin","linux")]
        [string]$platform
    )
    # set the URI to match the device specific query or a genreal query.
    if ($DeviceId){
        $URI="$($script:HuntressBaseURI)agents/$deviceid"    
    }
    else{
    # Limit each query to 50 results.
    $URI="$($script:HuntressBaseURI)agents?limit=50"
    }
    

    # Append the platform value if present.
    if ($platform){
        # Make sure that the platform value is in lower case.
        $platform=$platform.ToLower()

        $URI="$URI&platform=$platform"
    }

    if ($OrgId){
        $URI="$URI&organization_id=$orgid"
    }

    $data=[System.Collections.ArrayList]@()
    do {
        $rawdata=New-HuntressAPIQuery -URI $URI
        $agents=$rawdata.agents
        $agent=$rawdata.agent
        # Instead of returning a consistent data structure, Huntress uses "agents" when not using an id,
        # and "agent" when querying a specific entry. Accommodate both variations in a single command.
        if ($agents){
            foreach ($entry in $agents){
                    [void]$data.add($entry)
            }
        }
        if ($agent){
            foreach ($entry in $agent){
                    [void]$data.add($entry)
            }
        }
        $pagination=$rawdata.pagination
        if ($null -ne $pagination.next_page_url){
            $URI=$pagination.next_page_url
        }
        else {$URI=$null}
    }
    while ($null -ne $URI)
    $data | sort-object -property organization_id,hostname
}