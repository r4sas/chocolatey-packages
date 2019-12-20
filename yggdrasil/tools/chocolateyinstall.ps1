$ErrorActionPreference = 'Stop';

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir          = "$([Environment]::GetFolderPath('ProgramFiles'))\Yggdrasil"
$confDir         = "$([Environment]::GetFolderPath('CommonApplicationData'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

$url             = 'https://ci.appveyor.com/api/buildjobs/bmhigwngjgybqh50/artifacts/yggdrasil-develop-0.3.12-0060-x86.msi'
$url64           = 'https://ci.appveyor.com/api/buildjobs/bmhigwngjgybqh50/artifacts/yggdrasil-develop-0.3.12-0060-x64.msi'
$checksum        = '7c7faeac9bb60efe4ce996ceade9c94fda3a5e1dcd37fa8836794420e43b8e62'
$checksum64      = 'bfd5dccc5faa4789616014c29f1add3eaa9a5a112eef6543f0dae9dae9a8c2a2'

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

Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Start service.lnk" `
  -targetPath "$toolsDir\service-start.bat" -workDirectory "$appDir" -description "Start yggdrasil service" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Restart service.lnk" `
  -targetPath "$toolsDir\service-restart.bat" -workDirectory "$appDir" -description "Restart yggdrasil service" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Stop service.lnk" `
  -targetPath "$toolsDir\service-stop.bat" -workDirectory "$appDir" -description "Stop yggdrasil service" -RunAsAdmin
