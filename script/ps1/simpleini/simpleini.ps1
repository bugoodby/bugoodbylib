$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

function Load-Ini( $Path )
{
	$inidata = @{}
	if ( Test-Path $Path ) {
		$lines = Get-Content $Path
		foreach ( $l in $lines ) {
			if ( $l -match "^;"){ continue }
			$p = $l.split("=", 2)
			if ( $p.length -eq 2 ) {
				$inidata.Add($p[0].Trim(), $p[1].Trim())
			}
		}
	}
	return $inidata
}
function Save-Ini( $Path, $IniData )
{
	$text = ""
	foreach ( $k in $IniData.Keys ) {
		$text += ( "$k=" + $IniData[$k] + "`r`n" )
	}
	[IO.File]::WriteAllText($Path, $text, [Text.Encoding]::GetEncoding("Shift_JIS"))
}

#load
$basedir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + "\\"
$ini = Load-Ini -Path ($basedir + "config.ini")
if ( -not $ini["width"] ) { $ini.Add("width", 500) }
if ( -not $ini["height"] ) { $ini.Add("height", 150) }

$ini
"------------"
foreach ($k in $ini.Keys) {
	if ( $ini[$k] ) {
		"$k is {0}" -f $ini[$k].GetType().FullName
	} else {
		"$k is null"
	}
}

#save
Save-Ini -Path ($basedir + "config2.ini") -inidata $ini

