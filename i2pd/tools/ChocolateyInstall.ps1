$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.28.0/i2pd_2.28.0_win32_mingw.zip'
$checksum = '3ACAABA6C123BBFAB4E2CF07AB0D755B36C2624837967BC0467274E9A6ADE36F'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.28.0/i2pd_2.28.0_win64_mingw.zip'
$checksum64 = '598B8887EA99601DB3F2679FC39F9AFFC5FBDE02ADD5B5075245FFE49A320B67'
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
