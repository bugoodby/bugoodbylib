$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\..\DebugTools.ps1

#==========
# .bat
#==========
Write-Host "--------------"
& ($ScriptDir + "sub.bat") "abc" "123"
Write-Host "ExitCode: $LastExitCode"
Write-Host "--------------"

#==========
# .bat
#==========
Write-Host "--------------"
$script = $ScriptDir + "sub.bat"
$args = "/c `" `"$script`" `"abc`" `"123`" `""
$proc = Start-Process -FilePath cmd.exe -ArgumentList $args -Wait -PassThru
Write-Host "ExitCode: $($proc.ExitCode)"
Write-Host "--------------"


#==========
# .rb
#==========
Write-Host "--------------"
$script = $ScriptDir + "sub.rb"
$args = "`"$script`" `"abc`" `"123`""
& ruby $args
Write-Host "ExitCode: $LastExitCode"
Write-Host "--------------"

#==========
# .rb
#==========
Write-Host "--------------"
$script = $ScriptDir + "sub.rb"
$args = "/c ruby `"$script`" `"abc`" `"123`""
$proc = Start-Process -FilePath cmd.exe -ArgumentList $args -Wait -PassThru
Write-Host "ExitCode: $($proc.ExitCode)"
Write-Host "--------------"


#==========
# .ttl
#==========
Write-Host "--------------"
$app = 'C:\Program Files (x86)\teraterm\ttpmacro.exe'
$script = $ScriptDir + "sub.ttl"
$args = "`"$script`" `"abc`" `"123`""
$proc = Start-Process -FilePath $app -ArgumentList $args -Wait -PassThru
Write-Host "ExitCode: $($proc.ExitCode)"
Write-Host "--------------"


#==========
# .txt
#==========
Write-Host "--------------"
& ($ScriptDir + "sub.txt")
Write-Host "--------------"

