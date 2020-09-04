$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.33.0/i2pd_2.33.0_win32_mingw.zip'
$checksum = 'b25a9ea4674fb637e194d1009ab9ada230e1c5f1bae53f887da5a11597b6e6e8'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.33.0/i2pd_2.33.0_win64_mingw.zip'
$checksum64 = 'ada894a57de451830dcd50320220233a2606ff255c1031988e7e9c4a463cabde'
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
