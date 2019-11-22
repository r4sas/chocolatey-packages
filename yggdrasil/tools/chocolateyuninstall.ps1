$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir          = "$([Environment]::GetFolderPath('ProgramFiles'))\Yggdrasil"
$startMenuDir    = "$([Environment]::GetFolderPath('CommonStartMenu'))\Programs\Yggdrasil"

# Remove shims
Uninstall-BinFile "yggdrasil"
Uninstall-BinFile "yggdrasilctl"

# Remove shortcuts from Start Menu
Remove-Item $startMenuDir -Recurse

# Stop and remove service if it was installed
if (Get-WmiObject -Class Win32_Service -Filter "Name='Yggdrasil'") {
  & sc stop "Yggdrasil"
  & sc delete "Yggdrasil"
}

# Remove binaries, but don't touch configs
Write-Host "We removing binaries, but doesn't touch your configs. You can still find them in '$appDir' directory"
Remove-Item "$appDir\yggdrasil.exe"
Remove-Item "$appDir\yggdrasilctl.exe"
