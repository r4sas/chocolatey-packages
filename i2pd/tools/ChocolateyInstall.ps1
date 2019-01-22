$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.23.0/i2pd_2.23.0_win32_mingw.zip'
$checksum = '1973B23E8A3475CBA70BBDD74FA431D991F98D1CAF44D21099C3FE9B7E3ED1A1'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.23.0/i2pd_2.23.0_win64_mingw.zip'
$checksum64 = '3F79809EFF534DD3A88ED259C126753935D97B5A1BF3AB836AF06F9E433DD353'
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
