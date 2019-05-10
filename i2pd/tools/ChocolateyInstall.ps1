$ErrorActionPreference = 'Stop'; # stop on all errors
$packagename = 'i2pd'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://github.com/PurpleI2P/i2pd/releases/download/2.25.0/i2pd_2.25.0_win32_mingw.zip'
$checksum = '25BCBDD4F8593CDF08BB45A88D407CCC86920575F3032030A86EDA8A9023FE87'
$checksumType = 'sha256'
$url64 = 'https://github.com/PurpleI2P/i2pd/releases/download/2.25.0/i2pd_2.25.0_win64_mingw.zip'
$checksum64 = 'C2D0EF2FF7B6704FBCBB6864EF22B4AED03B64B92E11F33DE575777ECC2BCB42'
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
