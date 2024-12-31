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

    # Check if the IP addresses range is valid (we check only the private IP addresses)
    $privateRanges = @(
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16"
    )
    foreach ($range in $privateRanges) {
        if (Test-IpInRange -Ip $startIp -Range $range -and Test-IpInRange -Ip $endIp -Range $range) {
            return $true
        }
    }
    throw "[ERROR] Only IP addresses in the private range are allowed."

    Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0

    $ipRange = @()
    $currentIp = [System.Net.IPAddress]::Parse($StartIP)
    while ($currentIp -le $ipEnd) {
        $ipRange += $currentIp.ToString()
        $currentIp = [System.Net.IPAddress]::Parse(($currentIp.GetAddressBytes() | ForEach-Object { $_ }) -join ".")
        $currentIp = [System.Net.IPAddress]::Parse(([System.BitConverter]::ToUInt32($currentIp.GetAddressBytes(), 0) + 1).ToString())
    }

    if ($PSBoundParameters.ContainsKey('StartPort')) {
        $portStart = [int]$StartPort
        $portEnd = [int]$EndPort

        foreach ($ipAddress in $ipRange) {
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete ($ipRange.IndexOf($ipAddress) / $ipRange.Count * 100)
            $portStart..$portEnd | ForEach-Object {
                $port = $_
                $portResult = Test-Connection -IPv4 $ipAddress -TcpPort $port -Count 1 -Quiet
                if ($portResult) {
                    "IP: $ipAddress | Port: $port | Status: Open" | Out-File -FilePath "report-ipscan.txt" -Append
                }
                else {
                    "IP: $ipAddress | Port: $port | Status: Closed" | Out-File -FilePath "report-ipscan.txt" -Append
                }
            }
        }
        Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 100
    }
    else {
        foreach ($ipAddress in $ipRange) {
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete ($ipRange.IndexOf($ipAddress) / $ipRange.Count * 100)
            $ipStatus = Test-Connection -IPv4 $ipAddress -Count 1 -Quiet
            if ($ipStatus) {
                "IP: $ipAddress | Status: Up" | Out-File -FilePath "report-ipscan.txt" -Append
            }
            else {
                "IP: $ipAddress | Status: Down" | Out-File -FilePath "report-ipscan.txt" -Append
            }
        }
        Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 100
    }
}