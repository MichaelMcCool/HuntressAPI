function Get-HuntressOrganization {
    param (
        [Parameter(Mandatory=$false,Position=0)]
        [int]$id
    )

    if ($id){
        $URI="$($script:HuntressBaseURI)organizations/$id"
    }
    else {
        $URI="$($script:HuntressBaseURI)organizations"
    }
    
    $data=[System.Collections.ArrayList]@()
    do {
        $rawdata=New-HuntressAPIQuery $URI


        # Instead of returning a consistent data structure, Huntress uses "organizations" when not using an id,
        # and "organization" when querying a specific entry. Try and accommodate both variations.
        $organizations=$rawdata.organizations
        $organization=$rawdata.organization

        if ($organizations){
            foreach ($entry in $organizations){
                    [void]$data.add($entry)
            }
        }
        if ($organization){
            foreach ($entry in $organization){
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
    $data | sort-object -property Name
}