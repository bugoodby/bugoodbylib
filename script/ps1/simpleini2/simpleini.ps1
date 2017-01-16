$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Load-Ini( $Path )
{
	$key = ""
	$inidata = @{}
	if ( Test-Path $Path ) {
		$lines = Get-Content $Path
		foreach ( $l in $lines ) {
			if ( $l -match "^;"){ continue }
			if ( $l.Trim().Length -eq 0 ) { continue }
			if ( $l -match "\[(.*)\]" ) {
				$key = $matches[1]
			} else {
				if ( $key -ne "" ) {
					if ( -not $inidata[$key] ) { $inidata[$key] = @() }
					$inidata[$key] += $l.Trim()
				}
			}
		}
	}
	return $inidata
}

#load
$basedir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + "\\"
$ini = Load-Ini -Path ($basedir + "config.ini")

$ini
"------------"
foreach ($k in $ini.Keys) {
	if ( $ini[$k] ) {
		"$k is {0}" -f $ini[$k].GetType().FullName
	} else {
		"$k is null"
	}
}

