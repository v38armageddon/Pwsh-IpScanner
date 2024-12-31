#
# Module manifest for module 'Pwsh-IpScanner'
#
# Generated by: v38armageddon
#
# Generated on: 10/01/2023
#

@{
    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = 'e790d381-af5c-4f67-8384-951d375e823b'

    # Author of this module
    Author = 'v38armageddon'

    # Company or vendor of this module
    CompanyName = 'v38armageddon'

    # Copyright statement for this module
    Copyright = '(c) 2023 - 2025 - v38armageddon - All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'IP Scanner for PowerShell, made in PowerShell.'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Test-IpAddress', 'Test-IpRange')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @('Test-IpAddress', 'Test-IpRange')

    # See https://www.reddit.com/r/PowerShell/comments/10ejvyp/comment/j4ryl18/?context=3
    NestedModules = @('Test-IpAddress.psm1', 'Test-IpRange.psm1')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('ip-scanner', 'port-scanner', 'powershell-module')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/v38armageddon/Pwsh-IpScanner/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/v38armageddon/Pwsh-IpScanner'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'Rewrite completly the Test-IpRange Module.'

            # Prerelease string of this module
            # Prerelease = 'Alpha'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $true

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

