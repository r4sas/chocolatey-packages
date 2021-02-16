$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.36.0/i2pd_2.36.0_win32_mingw.zip'
$checksum = '155209fd53c10b76311dd230ebe017bb7dd12700d7f722c973ec40f8f7e3d854'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.36.0/i2pd_2.36.0_win64_mingw.zip'
$checksum64 = '550eddb45f37d2714f6f2e1febf3d41c0b30287f9ed046a8b564ded51787f869'
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
