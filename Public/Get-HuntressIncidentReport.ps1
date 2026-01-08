function Get-HuntressIncidentReport {
    param (
        [Parameter(ParameterSetName="Individual")]
        [int]$incidentid,
        [ValidateSet("footholds","monitored_files","ransomware_canaries","antivirus_detections","process_detections","managed_identity","mde_detections","siem_detections","favicon_detections")]
        [Parameter(ParameterSetName="Global")]
        [Parameter(ParameterSetName="GlobalOrg")]
        [Parameter(ParameterSetName="GlobalAgent")]
        [string]$IndicatorType,
        [ValidateSet("sent","closed","dismissed","auto_remediating","deleting")]
        [Parameter(ParameterSetName="Global")]
        [Parameter(ParameterSetName="GlobalOrg")]
        [Parameter(ParameterSetName="GlobalAgent")]
        [string]$status,
        [ValidateSet("low","high","critical")]
        [Parameter(ParameterSetName="Global")]
        [Parameter(ParameterSetName="GlobalOrg")]
        [Parameter(ParameterSetName="GlobalAgent")]
        [string]$Severity,
        [ValidateSet("windows","darwin","microsoft_365","google","linux","other")]
        [Parameter(ParameterSetName="Global")]
        [Parameter(ParameterSetName="GlobalOrg")]
        [Parameter(ParameterSetName="GlobalAgent")]
        [string]$Platform,
        [Parameter(ParameterSetName="GlobalOrg")]
        [int]$OrgId,
        [Parameter(ParameterSetName="GlobalAgent")]
        [int]$AgentId
    )

    if ($incidentid){
        $URI="$($script:HuntressBaseURI)incident_reports/$incidentid"
    }
    else {
        $URI="$($script:HuntressBaseURI)incident_reports?limit=50"
    }

    if ($IndicatorType){
        $IndicatorType=$IndicatorType.tolower()
        $URI="$URI&indicator_type=$indicatortype"
    }

    if ($Status){
        $Status=$Status.tolower()
        $URI="$URI&status=$Status"
    }

    if ($severity){
        $severity=$severity.tolower()
        $URI="$URI&severity=$severity"
    }

    if ($platform){
        $platform=$platform.tolower()
        $URI="$URI&platform=$platform"
    }

    if ($OrgId){
        $URI="$URI&organization_id=$orgid"
    }

    if ($AgentId){
        $URI="$URI&agent_id=$agentid"
    }

    $data=[System.Collections.ArrayList]@()
    do {
        $rawdata=New-HuntressAPIQuery -URI $URI
        $reports=$rawdata.incident_reports
        $report=$rawdata.incident_report
        # Instead of returning a consistent data structure, Huntress uses "incident_reports" when not using an id,
        # and "incident_report" when querying a specific entry. Accommodate both variations in a single command.
        if ($reports){
            foreach ($entry in $reports){
                    [void]$data.add($entry)
            }
        }
        if ($report){
            foreach ($entry in $report){
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