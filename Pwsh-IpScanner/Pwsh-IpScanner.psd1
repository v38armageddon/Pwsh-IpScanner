#
# Module manifest for module 'Pwsh-IpScanner'
#
# Generated by: v38armageddon
#
# Generated on: 10/01/2023
#

@{

# Version number of this module.
ModuleVersion = '0.0.2'

# ID used to uniquely identify this module
GUID = 'e790d381-af5c-4f67-8384-951d375e823b'

# Author of this module
Author = 'v38armageddon'

# Company or vendor of this module
CompanyName = 'v38armageddon'

# Copyright statement for this module
Copyright = '(c) v38armageddon. All rights reserved.'

# Description of the functionality provided by this module
Description = 'IP Scanner for PowerShell, made in PowerShell.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Test-IpAddress', 'Test-IpRange')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @('Test-IpAddress', 'Test-IpRange')

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
        ReleaseNotes = 'Split functions into two files.'

        # Prerelease string of this module
        Prerelease = 'Alpha'

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable
}
