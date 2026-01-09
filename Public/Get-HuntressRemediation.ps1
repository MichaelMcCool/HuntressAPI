function Get-HuntressRemediation {
    [CmdletBinding(DefaultParameterSetName='Global')]
    param (
        [Parameter(Mandatory=$true)]
        [int]$IncidentReportId,
        [Parameter(ParameterSetName="Individual",Mandatory=$false)]
        [int]$RemediationId,
        [Parameter(ParameterSetName="Global")]
        [string]$types,
        [Parameter(ParameterSetName="Global")]
        $Statuses
    )

    if ($RemediationId){
        $URI="$($script:HuntressBaseURI)$incidentReportId/remediations/$remediationid"
    }
    else {
        $URI="$($script:HuntressBaseURI)$incidentReportId/remediations?limit=50"
    }

    if ($types){
        # possible values: assisted, manual, containment
        $goodvalues=@("assisted","manual","containment")
        $array=[System.Collections.ArrayList]@()
        $badarray=[System.Collections.ArrayList]@()
        if (($types.gettype()).Name -eq 'String'){
            $temparray=$types.split(',').trim()
            $array=[System.Collections.ArrayList]@()
            $badarray=[System.Collections.ArrayList]@()
            foreach ($entry in $temparray){
                if ($goodvalues -contains $entry){
                    [void]$array.Add($entry)
                }
                else {
                    [void]$badarray.add($entry)
                }
            }
        }
        elseif (($types.gettype()).BaseType -eq 'System.Array'){
            foreach ($entry in $Types){
                if ($goodvalues -contains $entry){
                    [void]$array.Add($entry)
                }
                else {
                    [void]$badarray.add($entry)
                }
            }
        }
        else {
            throw "Provided object type for -Types parameter is unsupported. Object must be a string or array."
        }
        if (($badarray | measure-object).count -gt 0){
            write-error "ERROR: -Types unsupported value(s): $($badarray -join ', ')"
            throw "The parameter -Types only supports the following values: $($goodvalues -join ', ')"
        }
        $array
    }

    # $data=[System.Collections.ArrayList]@()
    # do {
    #     $rawdata=New-HuntressAPIQuery -URI $URI
    #     $escalations=$rawdata.escalations
    #     $escalation=$rawdata.escalation
    #     # Instead of returning a consistent data structure, Huntress uses "escalations" when not using an id,
    #     # and "escalation" when querying a specific entry. Accommodate both variations in a single command.
    #     if ($escalations){
    #         foreach ($entry in $escalations){
    #                 [void]$data.add($entry)
    #         }
    #     }
    #     if ($escalation){
    #         foreach ($entry in $escalation){
    #                 [void]$data.add($entry)
    #         }
    #     }
    #     $pagination=$rawdata.pagination
    #     if ($null -ne $pagination.next_page_url){
    #         $URI=$pagination.next_page_url
    #     }
    #     else {$URI=$null}
    # }
    # while ($null -ne $URI)
    # $data
}