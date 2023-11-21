$ErrorActionPreference = 'Stop';

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir          = "$([Environment]::GetFolderPath('ProgramFiles'))\Yggdrasil"
$confDir         = "$([Environment]::GetFolderPath('CommonApplicationData'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

$url             = 'https://github.com/yggdrasil-network/yggdrasil-go/releases/download/v0.5.2/yggdrasil-0.5.2-x86.msi'
$url64           = 'https://github.com/yggdrasil-network/yggdrasil-go/releases/download/v0.5.2/yggdrasil-0.5.2-x64.msi'
$checksum        = '64efce7c5225b85694cc1bdb2ffb13a74299a302bb11a70732dd8c4d99da93ec'
$checksum64      = '1e9e7568a5bf47a76a57482cca712eedb6eab620f712bbc9fd45596ca7787e2f'

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
