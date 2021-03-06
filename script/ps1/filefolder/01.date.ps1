$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'


# create a file.
$CurrentTime = Get-Date -Format "yyyyMMdd_HHmmss"
$OutFile = $ScriptDir + "Tmp_" + $CurrentTime + ".txt"

if ( [IO.File]::Exists($OutFile) ) {
	Write-Host "File already exists: $OutFile"
} else {
	Write-Host "[create] $OutFile"
	New-Item -Path $OutFile -ItemType File > $null
}


# create a folder.
$CurrentTime = Get-Date -Format "yyyyMMdd_HHmmss"
$OutDir = $ScriptDir + "Tmp_" + $CurrentTime

if ( [IO.Directory]::Exists($OutDir) ) {
	Write-Host "Directory already exists: $OutDir"
} else {
	Write-Host "[create] $OutDir"
	New-Item -Path $OutDir -ItemType Directory > $null
}


