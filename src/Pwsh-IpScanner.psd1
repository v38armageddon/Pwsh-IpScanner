@{
    RootModule = 'Pwsh-IpScanner.psm1'
    FunctionsToExport = @('Test-IpAddress', 'Test-IpRange')

    # Utilities for publishing
    ModuleVersion = '0.1.0'
    Author = 'v38armageddon'
    Description = 'IP Scanner for PowerShell, made in PowerShell.'
    ProjectUri = 'https://github.com/v38armageddon/Pwsh-IpScanner'
    LicenseUri = 'https://github.com/v38armageddon/Pwsh-IpScanner/blob/master/LICENSE'
}