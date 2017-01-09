$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'



# cleanup a working folder.
$WorkDir = $ScriptDir + "workdir"
if ( [System.IO.Directory]::Exists($WorkDir) ) {
	Write-Host "[delete] $WorkDir"
	Remove-Item -LiteralPath $WorkDir -Force -Recurse | Out-Null
}
Write-Host "[create] $WorkDir"
New-Item -Path $WorkDir -ItemType Directory | Out-Null

