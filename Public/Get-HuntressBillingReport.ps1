function Get-HuntressBillingReport {
    param (
        [Parameter(ParameterSetName="Individual")]
        [Parameter(Mandatory=$false)]
        [int]$reportid,
        [Parameter(Mandatory=$false)]
        [Parameter(ParameterSetName="Global")]
        [ValidateSet("open","paid","failed","partial_refund","full_refund","draft","voided")]
        [string]$status
    )
    if ($reportid){
        $URI="$($script:HuntressBaseURI)billing_reports/$reportid"
    }
    else {
        $URI="$($script:HuntressBaseURI)billing_reports?limit=50"
    }

    if ($status){
        $URI="$URI&status=$status"
    }

    $data=[System.Collections.ArrayList]@()
    do {
        $rawdata=New-HuntressAPIQuery -URI $URI
        $reports=$rawdata.billing_reports
        $report=$rawdata.billing_report
        # Instead of returning a consistent data structure, Huntress uses "billing_reports" when not using an id,
        # and "billing_report" when querying a specific entry. Accommodate both variations in a single command.
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