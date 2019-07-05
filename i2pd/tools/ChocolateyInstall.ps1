$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.27.0/i2pd_2.27.0_win32_mingw.zip'
$checksum = 'C6835FB9790DF35BD26C09FF1A0E2CFDF11EAB2DCD0BFA9171F74907C51F428A'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.27.0/i2pd_2.27.0_win64_mingw.zip'
$checksum64 = '7C7291802455F0755B493FCF89419323F48B6758EE6FFB94D270F4D556F17DED'
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
