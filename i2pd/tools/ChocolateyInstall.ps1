$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.56.0/i2pd_2.56.0_win32_mingw.zip'
$checksum = 'f532d4cdbcbcbe155a744c88846a20e543a3c7010455be14d04d2a8a7c4c3567'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.56.0/i2pd_2.56.0_win64_mingw.zip'
$checksum64 = 'f0b15a69dff3c3092a0906d822cbf6fa4d148801dfe032fbe81ab9326eb40065'
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
