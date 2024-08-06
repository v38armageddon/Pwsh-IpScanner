<#
    .SYNOPSIS
        Scan a range of IP addresses.
    
    .DESCRIPTION
        You can scan a range of IP addresses from class A to class C and even, specify a range of port numbers.
    
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
        Test-IpRange -StartIP 192.168.1.1 -EndIP 192.168.1.254 -StartPort 1 -EndPort 65535
    
    .NOTES
        A file named "report-ipscan.txt" is generated when the command is finished to be executed.
#>
function Test-IpRange {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$StartIP,

        [Parameter(Mandatory=$true)]
        [string]$EndIP,

        [Parameter(Mandatory=$false)]
        [int]$StartPort,

        [Parameter(Mandatory=$false)]
        [int]$EndPort
    )

    # Detect if the PowerShell version is 7.0 or higher
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Error "This script requires PowerShell 7.0 or higher."
        return 255
    }
    
    $ipStart = [System.Net.IPAddress]::Parse($StartIP)
    $ipEnd = [System.Net.IPAddress]::Parse($EndIP)

    Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0

    $ipRange = [System.Net.IPAddress]::GetAddressBytes($ipStart)..[System.Net.IPAddress]::GetAddressBytes($ipEnd) | ForEach-Object {
        [System.Net.IPAddress]::Parse($_)
    }

    if ($PSBoundParameters.ContainsKey('StartPort')) {
        $portStart = [int]$StartPort
        $portEnd = [int]$EndPort

        foreach ($ipAddress in $ipRange) {
            $ipString = $ipAddress.ToString()
            $portStart..$portEnd | ForEach-Object {
                $port = $_
                $socket = New-Object System.Net.Sockets.TcpClient
                try {
                    $socket.Connect($ipString, $port)
                    $status = if ($socket.Connected) { "Open" } else { "Closed" }
                }
                catch {
                    $status = "Error"
                }
                "IP: $ipString | Port: $port | Status: $status" | Out-File -FilePath "report-ipscan.txt" -Append
            }
        }
    }
    else {
        foreach ($ipAddress in $ipRange) {
            $ipString = $ipAddress.ToString()
            $ping = New-Object System.Net.NetworkInformation.Ping
            $socket = $ping.Send($ipString)
            $status = if ($socket.Status -eq "Success") { "Up" } else { "Down" }
            "IP: $ipString | Status: $status" | Out-File -FilePath "report-ipscan.txt" -Append
        }
    }
}