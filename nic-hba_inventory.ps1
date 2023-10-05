$Report=@()
Get-Datacenter | % {
    $datacenter=$_
    foreach($esx in Get-VMhost -Location $datacenter){
        $esxcli = Get-EsxCli -VMHost $esx
        $nic = Get-VMHostNetworkAdapter -VMHost $esx | Select -First 1
        $report += Get-VMHostHBA -VMHost $esx -Type FibreChannel | where {$_.Status -eq "online"} |
        Select @{N="Dataceter";E={$datacenter.Name}},
            @{N="VMHost";E={$esx.Name}},
            @{N="HostName";E={$($_.VMHost | Get-VMHostNetwork).HostName}},
            @{N="ver":E={$esx.version}},
            @{N="Manf";E={$esx.Manufacturer}},
            @{N="Hostmodel";E={$esx.Model}},
            @{Name="SeriaNumber";Expression={$esx.ExtensionData.Hardware.SystemInfo.OtherIdentifyingInfo |Where-Object {$_.IdentifierType.Key -eq "Servicetag"} |Select-Object -ExpandProperty IdentifierValue}},
            @{N="Cluster";E={
                if($esx.ExtensionData.Parent.Type -ne "ClusterComputeResource"){"Stand alone host"}
                else{
                    Get-view -Id $esx.ExtensionData.Parent | Select -ExpandProperty Name
                }}},
            Device,Model,Status
            @{N="WWW";E={((("{0:X}" -f $_.PortWorldWideName).ToLower()) -replace "(\w{2})",'$1:').TrimEnd(':')}},
            @{N="fnicdriver";E={$esxcli.software.vib.list() | ? {$_.Name -match ".*$($hba.hbadriver).*"} | Select -First 1 -Expand Version}},
            @{N="fnicvendor";E={$esxcli.software.vib.list() | ? {$_.Name -match ".*$($hba.hbadriver).*"} | Select -First 1 -Expand Vendor}},
            @{N="enicdriver";E={$esxcli.system.module.get("enic").version}},
            @{N="enicvendor";E={$esxcli.software.vib.list() | ? {$_.Name -match ".net.*"} | Select -First 1 -Expand Vendor}}
    }
}
$report | export-csv .\Report.csv -notypeinformation