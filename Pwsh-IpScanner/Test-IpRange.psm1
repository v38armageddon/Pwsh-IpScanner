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
        [int]$StartPort,

        [Parameter(Mandatory=$false)]
        [int]$EndPort
    )

    if ($PSBoundParameters.ContainsKey('StartPort')) {
        for ($j = $StartPort; $j -le $EndPort; $j++) {
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0
            for ($i = [IPAddress]::Parse($StartIP); $i.Address -le [IPAddress]::Parse($EndIP).Address; $i = [IPAddress]::Parse($i.Address + 1)) {
                $ip = $i.ToString()
                $portResult = Test-Connection -TargetName $ip -TcpPort $j -Quiet
                if ($portResult) {
                    "IP: $($ip) | Port: $j | Status: Open" | Out-File .\report-ipscan.txt -Append
                }
                else {
                    "IP: $($ip) | Port: $j | Status: Closed" | Out-File .\report-ipscan.txt -Append
                }
            }
            Write-Progress -Activity "Scanning IP address" -Status "Scan complete" -PercentComplete 100
        }
    }
    else {
        for ($i = [IPAddress]::Parse($StartIP); $i.Address -le [IPAddress]::Parse($EndIP).Address; $i = [IPAddress]::Parse($i.Address + 1)) {
            Write-Progress -Activity "Scanning IP address" -Status "Scan in progress" -PercentComplete 0
            $ip = $i.ToString()
            $ipResult = Test-Connection -TargetName $ip -Ping -Quiet
            if ($ipResult) {
                "IP: $ip | Status: Up" | Out-File .\report-ipscan.txt -Append
            }
            else {
                "IP: $ip | Status: Down" | Out-File .\report-ipscan.txt -Append
            }
            Write-Progress -Activity "Scanning IP address" -Status "Scan complete" -PercentComplete 100
        }
    }
}