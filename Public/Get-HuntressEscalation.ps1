function Get-HuntressEscalation {
    param (
        [Parameter(Mandatory=$false)]
        [int]$escalationid
    )

    if ($escalationid){
        $URI="$($script:HuntressBaseURI)escalations/$escalationid"
    }
    else {
        $URI="$($script:HuntressBaseURI)escalations?limit=50"
    }

    $data=[System.Collections.ArrayList]@()
    do {
        $rawdata=New-HuntressAPIQuery -URI $URI
        $escalations=$rawdata.escalations
        $escalation=$rawdata.escalation
        # Instead of returning a consistent data structure, Huntress uses "escalations" when not using an id,
        # and "escalation" when querying a specific entry. Accommodate both variations in a single command.
        if ($escalations){
            foreach ($entry in $escalations){
                    [void]$data.add($entry)
            }
        }
        if ($escalation){
            foreach ($entry in $escalation){
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
    $data
}