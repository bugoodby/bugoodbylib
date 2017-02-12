$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

function Load-Ini( $Path )
{
	$key = ""
	$inidata = @{}
	if ( Test-Path $Path ) {
		#$enc = [Text.Encoding]::GetEncoding("Shift_JIS")
		$enc = New-Object System.Text.UTF8Encoding($false)
		$sr = New-Object System.IO.StreamReader($Path, $enc)
		while (($l = $sr.ReadLine()) -ne $null) {
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

