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
function Test-IpAddress {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [String]$IpAddress,
        [parameter(Mandatory=$false)]
        [String]$Port
    )

    # Detect if the PowerShell version is 7.0 or higher
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Error "This script requires PowerShell 7.0 or higher."
        return 255
    }

    Write-Progress -Activity "Scanning IP address" -Status "$IpAddress" -PercentComplete 0
    # If the user specify a port number, we will test the connection with this port number.
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
        # Do a regular ping, duh
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