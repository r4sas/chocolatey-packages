$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$confDir         = "$([Environment]::GetFolderPath('CommonApplicationData'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

$softwareName   = 'Yggdrasil Network*'

# Remove package, it don't touch configs
Write-Host "We removing package, but doesn't touch your configs. You can still find them in '$confDir' directory"

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $file = "$($key.UninstallString)"
  $silentArgs = "$($key.PSChildName) /quiet"
  $file = ''

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'msi'
    silentArgs     = $silentArgs
    validExitCodes = @(0)
    file           = $file
  }

  Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}

# Remove shims
Uninstall-BinFile "yggdrasil"
Uninstall-BinFile "yggdrasilctl"

# Remove shortcuts from Start Menu
Remove-Item $startMenuDir -Recurse
