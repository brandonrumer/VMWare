$cluster = "Clustername"

get-vmhost | Foreach {
    write-host $_.Name
    get-VMHostAdvancedConfiguration -VMHost $_ -Name NFS.MaxVolumes -warningaction 0
    get-VMHostAdvancedConfiguration -VMHost $_ -Name Net.TcpIpHeapSize -warningaction 0
    get-VMHostAdvancedConfiguration -VMHost $_ -Name Net.TcpIpHeapMax -warningaction 0
}