get-vmhost | foreach {
    write-host $_.Name
    get-vmhostntpserver
    get-vmhostservice | where-object {$_.key -eq "ntpd"}
}