$ErrorActionPreference = 'Stop';

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir          = "$([Environment]::GetFolderPath('ProgramFiles'))\Yggdrasil"
$confDir         = "$([Environment]::GetFolderPath('CommonApplicationData'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

$url             = 'https://ci.appveyor.com/api/buildjobs/1g7v6hn29k7l8xbs/artifacts/yggdrasil-0.3.15-x86.msi'
$url64           = 'https://ci.appveyor.com/api/buildjobs/1g7v6hn29k7l8xbs/artifacts/yggdrasil-0.3.15-x64.msi'
$checksum        = '26802d62a8bbbd7d53850baf1dbcd8dc6a190873f48aec991308fd2f90c8cff4'
$checksum64      = '1145620ac9db09175fdd532e354d787d3e6441f742a481ec743e0e1e68def5c1'

$packageArgs     = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'

  url            = $url
  url64bit       = $url64

  checksum       = $checksum
  checksumType   = 'sha256'
  checksum64     = $checksum64
  checksumType64 = 'sha256'

  softwareName   = 'Yggdrasil Network*'
  silentArgs     = '/quiet'
  validExitCodes = @(0)
}

# Backup old configuration
if (Test-Path "$confDir\yggdrasil.conf" -PathType Leaf) {
  $date = Get-Date -format "yyyyMMdd"
  Write-Host "Backing up configuration file to yggdrasil.conf.$date"
  Copy-Item $confDir\yggdrasil.conf -Destination $confDir\yggdrasil.conf.$date
}

Install-ChocolateyPackage @packageArgs

Install-BinFile "yggdrasil" "$appDir\yggdrasil.exe"
Install-BinFile "yggdrasilctl" "$appDir\yggdrasilctl.exe"

# Creating shortcuts in Start Menu
if (-not (Test-Path -Path $startMenuDir)) {
  New-Item -Path $startMenuDir -ItemType Directory
}

# Get PowerShell executable path
$psPath = (Get-Command powershell.exe).Path

Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Start service.lnk" `
  -targetPath $psPath -Arguments "Start-Service -name 'Yggdrasil'" `
  -workDirectory "$appDir" -description "Start yggdrasil service" -IconLocation "$toolsDir\yggdrasil.ico" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Restart service.lnk" `
  -targetPath $psPath -Arguments "Restart-Service -name 'Yggdrasil'" `
  -workDirectory "$appDir" -description "Restart yggdrasil service" -IconLocation "$toolsDir\yggdrasil.ico" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Stop service.lnk" `
  -targetPath $psPath -Arguments "Stop-Service -name 'Yggdrasil'" `
  -workDirectory "$appDir" -description "Stop yggdrasil service" -IconLocation "$toolsDir\yggdrasil.ico" -RunAsAdmin
