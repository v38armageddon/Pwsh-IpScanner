function Scan-IpAddress {
    <#
    .SYNOPSIS
        Scan a specific IP Address.
    .DESCRIPTION
        You can scan a specific IP Address and even with a specific port number. It allow you to determine if X IP (and X port number) is pingable or not.
    .PARAMETER
        -IpAddress
            Specifies the IP address.
        -Port
            Specifies the port number.
    .EXAMPLE
        Scan-IpAddress -IpAddress 1.1.1.1
        Scan-IpAddress -IpAddress 192.168.1.2 - Port 25565
    #>

    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$IpAddress,
        [parameter(Mandatory=$false)]
        [String]$Port
    )

    if ($PSBoundParameters.ContainsKey('Port')) {
        Test-Connection -IPv4 $IpAddress -Ping -Quiet | Out-File report-ipscan.txt
        Test-Connection -IPv4 $IpAddress -TcpPort $Port | Out-File report-portscan.txt
    }
    else {
        Test-Connection -IPv4 $IpAddress -Ping
        Out-File report-scan.txt
    }   
}

function Scan-IpRange {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$StartIP,

        [Parameter(Mandatory=$true)]
        [string]$EndIP,

        [int]$Port = 80
    )

    $network = $IpAddress
    $range = (1..254)
    $reachableIpAddresses = @()

    $ErrorActionPreference = 'silentlycontinue'

    foreach ($add in $range) {
        $ipAddress = "$network.$add"
        if (Test-NetConnection -RemoteAddress $ipAddress -Port $port -ErrorAction SilentlyContinue) {
            $reachableIpAddresses += $ipAddress
        }
    }

    $reachableIpAddresses | Out-File -FilePath .\report-scan.txt
}