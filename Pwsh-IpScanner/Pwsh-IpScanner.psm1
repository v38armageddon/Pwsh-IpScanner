function Test-IpAddress {
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
    Test-IpAddress -IpAddress 1.1.1.1
    .EXAMPLE
    Test-IpAddress -IpAddress 192.168.1.2 - Port 25565
    
    .NOTES
    A file named "report-ipscan.txt" is generated when the command is finished to be executed.
    #>

    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$IpAddress,
        [parameter(Mandatory=$false)]
        [String]$Port
    )

    Write-Progress -Activity "Scanning IP address" -Status "$IpAddress" -PercentComplete 0

    if ($PSBoundParameters.ContainsKey('Port')) {
        $portResult = Test-Connection -IPv4 $IpAddress -TcpPort $Port -Quiet
        if ($portResult) {
            "IP: $IpAddress | Port: $Port | Status: Open" | Out-File .\report-ipscan.txt -Append
        }
        else {
            "IP: $IpAddress | Port: $Port | Status: Closed" | Out-File .\report-ipscan.txt -Append
        }
    }
    else {
        $ipResult = Test-Connection -IPv4 $IpAddress -Ping -Quiet
        if ($ipResult) {
            "IP: $IpAddress | Status: Up" | Out-File .\report-ipscan.txt -Append
        }
        else {
            "IP: $IpAddress | Status: Down" | Out-File .\report-ipscan.txt -Append
        }
    }
    Write-Progress -Activity "Scanning IP address" -Status "$IpAddress" -PercentComplete 100
}

function Test-IpRange {
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
    Test-IpRange -StartIP 192.168.1.1 -EndIP 192.168.1.254
    .EXAMPLE
    Test-IpRange -StartIP 192.168.1.1 -EndIP 192.168.1.254 -StartPort 1 -EndPort 65535
    
    .NOTES
    A file named "report-ipscan.txt" is generated when the command is finished to be executed.
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

    $startIp = [System.Net.IPAddress]::Parse($StartIP).Address
    $endIp = [System.Net.IPAddress]::Parse($EndIP).Address
    $startIpDouble = [double]$startIp
    $endIpDouble = [double]$endIp

    Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0

    if ($PSBoundParameters.ContainsKey('StartPort')) {
        for ($j = $StartPort; $j -le $EndPort; $j++) {
            for ($i = $startIpDouble; $i -le $endIpDouble; $i++) {
                $ip = [System.Net.IPAddress]::Parse($i)
                $portResult = Test-Connection -IPv4 $ip.ToString() -TcpPort $j -Quiet
                if ($portResult) {
                    "IP: $ip | Port: $j | Status: Open" | Out-File .\report-ipscan.txt -Append
                }
                else {
                    "IP: $ip | Port: $j | Status: Closed" | Out-File .\report-ipscan.txt -Append
                }
            }
        }
    }
    else {
        for ($i = $startIpDouble; $i -le $endIpDouble; $i++) {
            $ip = [System.Net.IPAddress]::Parse($i)
            $ipResult = Test-Connection -IPv4 $ip.ToString() -Ping -Quiet

            if ($ipResult) {
                "IP: $ip | Status: Up" | Out-File .\report-ipscan.txt -Append
            }
            else {
                "IP: $ip | Status: Down" | Out-File .\report-ipscan.txt -Append
            }
        }
    }
    Write-Progress -Activity "Scanning IP address" -Status "Scan complete" -PercentComplete 100
}