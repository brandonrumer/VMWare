# File should have one column with 'host' as the column name
$file = import-csv .\hosts.csv

foreach ($esxihost in $file)
{
    $esxcli = get-esxcli -vmhost $esxhost.host -V2
        $params = @{
            network = '10.10.10.0/24'
            gateway = '10.10.10.1'
            netstack = 'vmotion'
        }
    $esxcli.network.ip.route.ipv4.add.Invoke($params)
}
