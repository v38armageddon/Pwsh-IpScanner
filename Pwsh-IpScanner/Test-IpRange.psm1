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

    $ipStart = [System.Net.IPAddress]::Parse($StartIP)
    $ipEnd = [System.Net.IPAddress]::Parse($EndIP)

    $startIp = [System.BitConverter]::ToUInt32($ipStart.GetAddressBytes(), 0)
    $endIp = [System.BitConverter]::ToUInt32($ipEnd.GetAddressBytes(), 0)

    Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0

    if ($PSBoundParameters.ContainsKey('StartPort')) {
        # Scan IP range and port range
        $portrange = $StartPort..$EndPort
        $iprange = $startIp..$endIp
        $result = $iprange | foreach-object {
            $ip = ([System.Net.IPAddress]::Parse([System.Net.IPAddress]::Parse($_).GetAddressBytes())) 
            Test-NetConnection $ip -port $portrange
            "IP: $ip | Port: $portrange | Result: $result" | Out-File .\report-ipscan.txt -Append
            $percentComplete = ((($_ - $startIp) / ($endIp - $startIp)) * 100)
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete $percentComplete
        }
    }
    else {
        # Scan IP range
        $iprange = $startIp..$endIp
        $result = $iprange | foreach-object {
            $ip = ([System.Net.IPAddress]::Parse([System.Net.IPAddress]::Parse($_).GetAddressBytes()))
            Test-NetConnection $ip
            "IP: $ip | Result: $result" | Out-File .\report-ipscan.txt -Append
            $percentComplete = ((($_ - $startIp) / ($endIp - $startIp)) * 100)
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete $percentComplete
        }
    }
    Write-Progress -Activity "Scanning IP address" -Status "Scan complete" -PercentComplete 100
}