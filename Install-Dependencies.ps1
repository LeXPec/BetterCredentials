#######################################################################################################################
#                                                                                                                     #
#                                                  INSTALL                                                            #
#                                                DEPENDENCIES                                                         #
#                                                                                                                     #
#######################################################################################################################

#---------------------------------------------------------------------------------------------------------------------#
# Resource List                                                                                                       #
#---------------------------------------------------------------------------------------------------------------------#

# Packages
$packages = [ordered]@{
    'HaemmerElectronics.SeppPenner.WindowsHello' = '1.0.0.1'
}

#---------------------------------------------------------------------------------------------------------------------#
# Provider Parameters                                                                                                 #
#---------------------------------------------------------------------------------------------------------------------#

# NuGet.org
$packageParams = @{
    Destination      = Join-Path $PSScriptRoot 'lib'
    ProviderName     = 'NuGet'
    Source           = 'https://www.nuget.org/api/v2'
    SkipDependencies = $true
    ExcludeVersion   = $true
    Confirm          = $false
    Force            = $true
}

#---------------------------------------------------------------------------------------------------------------------#
# docs                                                                                                                #
#---------------------------------------------------------------------------------------------------------------------#

$docsPath = Join-Path $PSScriptRoot 'docs'

#---------------------------------------------------------------------------------------------------------------------#
# Installation                                                                                                        #
#---------------------------------------------------------------------------------------------------------------------#

# Package Directory
if ( -not ( Test-Path $packageParams.Destination ) ) {
    Write-Host "Installing Directory : $($packageParams.Destination)"
    New-Item -ItemType Directory -Path $packageParams.Destination > $null
}

# Packages
foreach ( $package in $packages.GetEnumerator() ) {
    Write-Host "Installing Package : $($package.Key) v$($package.Value)"
    Install-Package @packageParams -Name $package.Key -RequiredVersion $package.Value > $null
}

# WindowsHello Lib
$windowsHelloLibPath = "$PSScriptRoot\lib\HaemmerElectronics.SeppPenner.WindowsHello\lib"

Write-Host "Copying File : Documentation\GhostDoc\WindowsHello.chm"
Move-Item -Path "$windowsHelloLibPath\Documentation\GhostDoc\WindowsHello.chm" -Destination "$PSScriptRoot\" -Force

Write-Host "Copying File : net48\WindowsHello.dll"
Move-Item "$windowsHelloLibPath\net48\WindowsHello.dll" -Destination "$PSScriptRoot\" -Force

Start-Sleep -Milliseconds 250

# Clean Lib
Write-Host "Removing Directory File lib"
Remove-Item -Path "$PSScriptRoot\lib" -Recurse -Confirm:$false -Force
