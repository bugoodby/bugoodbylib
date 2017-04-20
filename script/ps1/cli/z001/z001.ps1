$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

# tempディレクトリに移動
Get-Location
Set-Location $env:temp
Get-Location


#################################
$wpath = where.exe notepad
Write-Host $wpath
if ( ($wpath -eq $null) -or (!$wpath[0].contains("C:\Windows\notepad")) ) {
	Write-Host "[ERROR] command not found" -BackgroundColor Red -ForegroundColor White
} else {
	Write-Host "### TEST1 OK ###"
}

#################################
$path = $ScriptDir + 'z001.bat'
$text = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)
if ( !$text.contains("hogehoge") ) {
	Write-Host "[ERROR] string not found" -BackgroundColor Red -ForegroundColor White
} else {
	Write-Host "### TEST2 OK ###"
}
