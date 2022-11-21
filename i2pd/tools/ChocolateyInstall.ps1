$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.44.0/i2pd_2.44.0_win32_mingw.zip'
$checksum = 'c2bddc922198c31c94f6c6b4df8b0fb4c1f8fac9aebbfc1d69963bb946876074'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.44.0/i2pd_2.44.0_win64_mingw.zip'
$checksum64 = 'dc329941dbdd153d0aa6f22e0e20dfedba9d8ac12f4862be2c18b16abbfb6304'
$checksumType64 = 'sha256'

Install-ChocolateyZipPackage -packageName "$packagename" `
                             -UnzipLocation "$toolsDir" `
                             -Url "$url" `
                             -checksum "$checksum" `
                             -checksumType "$checksumType" `
                             -Url64 "$url64" `
                             -checksum64 "$checksum64" `
                             -checksumType64 "$checksumType64"

# Install configs and certificates if i2pd dir not available, otherwise just update certificates
$dataDir = Join-Path $Env:APPDATA 'i2pd'
if (Test-Path -Path $dataDir) {
    Write-Host "Updating i2pd certificates"
    Remove-Item $dataDir\certificates -Recurse
    Copy-Item $toolsDir\contrib\certificates -Destination $dataDir\certificates -Recurse
} else {
    Write-Host "Copying default configs and certificates"
    Copy-Item $toolsDir\contrib -Destination $dataDir -Recurse
}
