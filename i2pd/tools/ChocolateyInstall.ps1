$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.50.0/i2pd_2.50.0_win32_mingw.zip'
$checksum = '396fd53408ea8269e714b76832fd682bd0c77989150480daab159c01750d4b21'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.50.0/i2pd_2.50.0_win64_mingw.zip'
$checksum64 = 'e85ea24f6a41c3c0559fb1ad28efdf95ed6088738d7aaea012a4405806f10b9d'
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
