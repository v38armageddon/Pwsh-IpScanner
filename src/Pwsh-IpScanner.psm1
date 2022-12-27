function Scan-IpAddress {
    <#
    .SYNOPSIS
    Scan a specific IP Address.
    
    .DESCRIPTION
    You can scan a specific IP Address and even with a specific port number. It allow you to determine if X IP (and X port number) is pingable or not.
    
    .PARAMETER IpAddress
    Specifies the IP address.
    
    .PARAMETER Port
    Specifies the port number.
    
    .EXAMPLE
    Scan-IpAddress -IpAddress 1.1.1.1
    .EXAMPLE
    Scan-IpAddress -IpAddress 192.168.1.2 - Port 25565
    
    .NOTES
    A file named "report-ipscan.txt" (and "report-portscan.txt" if -Port specified) is generated when the command is finished to be executed.
    #>

    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$IpAddress,
        [parameter(Mandatory=$false)]
        [String]$Port
    )

    $ipResult = Test-Connection -IPv4 $IpAddress -Ping -Quiet
    if ($ipResult) {
        "IP: $IpAddress | Status: Up" | Out-File .\report-ipscan.txt -Append
    } else {
        "IP: $IpAddress | Status: Down" | Out-File .\report-ipscan.txt -Append
    }

    if ($PSBoundParameters.ContainsKey('Port')) {
        $portResult = Test-Connection -IPv4 $IpAddress -TcpPort $Port -Quiet
        if ($portResult) {
            "IP: $IpAddress | Port: $Port | Status: Open" | Out-File .\report-portscan.txt -Append
        } else {
            "IP: $IpAddress | Port: $Port | Status: Closed" | Out-File .\report-portscan.txt -Append
        }
    }
}

function Scan-IpRange {
    <#
    .SYNOPSIS
    Scan a range of IP addresses.
    
    .DESCRIPTION
    You can scan a range of IP addresses whenever it's CIDR and even specific a range of port numbers.
    
    .PARAMETER StartIP
    Give the first IP address to be scanned.
    
    .PARAMETER EndIP
    Give the last IP address to be scanned.
    
    .PARAMETER StartPort
    Give the first port to be scanned.
    
    .PARAMETER EndPort
    Give the last port to be scanned.

    .EXAMPLE
    Scan-IpRange -StartIP 192.168.1.1 -EndIP 192.168.1.254
    .EXAMPLE
    Scan-IpRange -StartIP 192.168.1.1 -EndIP 192.168.1.254 -StartPort 1 -EndPort 65535
    
    .NOTES
    A file named "report-ipscan.txt" (and "report-portscan.txt" if ports are specified) is generated when the command is finished to be executed.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$StartIP,

        [Parameter(Mandatory=$true)]
        [string]$EndIP,

        [Parameter(Mandatory=$false)]
        [string]$StartPort,

        [Parameter(Mandatory=$false)]
        [string]$EndPort
    )

    
}