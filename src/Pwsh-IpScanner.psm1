function Scan-IpAddress {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$IpAddress
        [parameter(Mandatory=$false)]
        [String]$Port
    )
    
    $port = ($port)
    $network = (192.168.1)
    $range = (1..254)

    $ErrorActionPreference = 'silentycontinue'

    $(foreach ($add in $range) {
        $ip = "{0}.{1}" -F $network,$add
        Write-Progress "Scanning Network" $ip -PercentComplete (($add/$range.Count)*100)
        if (Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $ip) {
            $socket = new-object System.Net.Socket.TcpClient($ip, $port)
            if ($socket.Connected) {
                "$ip port $port"
                $socket.Close()
            }
            else {
                "$ip port $port not open"
            }
        }
    }) | Out-File report-scan.txt
}

function Scan-IpRange {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$StartIp,
        [parameter(Mandatory=$true)]
        [String]$EndIp,
        [parameter(Mandatory=$false)]
        [String]$Port
    )


    $(foreach ($add in $range) {
        
    })
}