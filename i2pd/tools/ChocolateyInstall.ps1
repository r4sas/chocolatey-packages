$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.39.0/i2pd_2.39.0_win32_mingw.zip'
$checksum = '930d5e30d07c5faa26899f4bd756b23ba81a711895477e2c550717433e6c0789'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.39.0/i2pd_2.39.0_win64_mingw.zip'
$checksum64 = '4092346849bc107eac311c95138111ba5e4fcb0eb88410ebc8c190a2d197fb95'
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
