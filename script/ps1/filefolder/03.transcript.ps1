$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'



# cleanup a working folder.
$LogDir = $ScriptDir + "Log\"
if ( -not [System.IO.Directory]::Exists($LogDir) ) {
	Write-Host "[create] $LogDir"
	New-Item -Path $LogDir -ItemType Directory | Out-Null
}

$CurrentTime = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = $LogDir + "Log_" + $CurrentTime + ".txt"

Start-Transcript -Path $LogFile

Write-Host "*************************************"
Write-Host "           transcript                "
Write-Host "*************************************"
ps
ls



Stop-Transcript

