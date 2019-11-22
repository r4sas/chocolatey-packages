$ErrorActionPreference = 'Stop';

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir          = "$([Environment]::GetFolderPath('ProgramFiles'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

$url             = 'https://2203-115685026-gh.circle-artifacts.com/0/yggdrasil-0.3.11-windows-i386.exe'
$url64           = 'https://2203-115685026-gh.circle-artifacts.com/0/yggdrasil-0.3.11-windows-amd64.exe'
$ctlUrl          = 'https://2203-115685026-gh.circle-artifacts.com/0/yggdrasil-0.3.11-yggdrasilctl-windows-i386.exe'
$ctlUrl64        = 'https://2203-115685026-gh.circle-artifacts.com/0/yggdrasil-0.3.11-yggdrasilctl-windows-amd64.exe'

$packageArgs     = @{
  packageName    = 'yggdrasil'
  url            = $url
  url64bit       = $url64
  fileFullPath   = "$appDir\yggdrasil.exe"

  checksum       = '496239325ED34ADAEDE10A71D678BE6B4FA13273BAEE6A924D20EE5EC58B8C28'
  checksumType   = 'sha256'
  checksum64     = 'BC89CDBA3E5FF4D455805990BEEC3C0D29A88751B1F1E01687A10F71F320E522'
  checksumType64 = 'sha256'
}

$ctlPackageArgs  = @{
  packageName    = 'yggdrasilctl'
  url            = $ctlurl
  url64bit       = $ctlurl64
  fileFullPath   = "$appDir\yggdrasilctl.exe"

  checksum       = 'F21B510D95ED7463BAF493F3530A3C7B5A1B72DB0110A160433A8ECB4C7584B3'
  checksumType   = 'sha256'
  checksum64     = 'FCD3859F8C8546D1A46EBB6EB1227173C1A4D3AB168A3821BEA6E91356A662B3'
  checksumType64 = 'sha256'
}

# Installing executables
if (-not (Test-Path -Path $appDir)) {
  New-Item -Path $appDir -ItemType Directory
}

Get-ChocolateyWebFile @packageArgs
Get-ChocolateyWebFile @ctlPackageArgs

Install-BinFile "yggdrasil" "$appDir\yggdrasil.exe"
Install-BinFile "yggdrasilctl" "$appDir\yggdrasilctl.exe"

# Generating new configuration, or updating existent
if (Test-Path "$appDir\yggdrasil.conf" -PathType Leaf) {
  $date = Get-Date -format "yyyyMMdd"
  Write-Host "Backing up configuration file to yggdrasil.conf.$date"
  Copy-Item $appDir\yggdrasil.conf -Destination $appDir\yggdrasil.conf.$date
  Write-Host "Normalizing and updating yggdrasil.conf"
  $args = @(
    "-useconffile","$appDir\yggdrasil.conf.$date",
    "-normaliseconf"
  )
  & "$appDir\yggdrasil.exe" $args > "$appDir\yggdrasil.conf"
} else {
  Write-Host "Generating initial configuration file yggdrasil.conf"
  Write-Host "Please familiarise yourself with this file before starting Yggdrasil"
  $args = @(
    "-genconf"
  )
  & "$appDir\yggdrasil.exe" $args > "$appDir\yggdrasil.conf"
}

# Creating shortcuts in Start Menu
if (-not (Test-Path -Path $startMenuDir)) {
  New-Item -Path $startMenuDir -ItemType Directory
}

Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Install service.lnk" `
  -targetPath "$toolsDir\service-install.bat" -workDirectory "$appDir" -description "Install yggdrasil service" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Restart service.lnk" `
  -targetPath "$toolsDir\service-restart.bat" -workDirectory "$appDir" -description "Restart yggdrasil service" -RunAsAdmin
Install-ChocolateyShortcut -shortcutFilePath "$startMenuDir\Uninstall service.lnk" `
  -targetPath "$toolsDir\service-uninstall.bat" -workDirectory "$appDir" -description "Uninstall yggdrasil service" -RunAsAdmin
