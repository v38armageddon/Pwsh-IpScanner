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