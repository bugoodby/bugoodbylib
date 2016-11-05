$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0


function dumpbin( $file )
{
	$dumpLine = {
		PARAM([byte[]]$data)
		$line = ("{0:X8}: " -f $offset)
		$chars = ""
		foreach ($b in $data) {
			$line += ("{0:x2} " -f $b)
			if ($b -ge 0x20 -and $b -le 0x7e) {
				$chars += [char]$b
			} else {
				$chars += "."
			}
		}
		$line += "   " * (16 - $data.length)
		Write-Host $line, $chars
	}

	$allData = [System.IO.File]::ReadAllBytes($file)
	$offset = 0
	do {
		[byte[]]$ldata = $allData[$offset..($offset+15)]
		if ( $ldata.length -gt 0 ) {
			$dumpLine.Invoke($ldata)
		}
		$offset += 16
	} while ($ldata.length -gt 0)
}



if ($args.length -eq 0) {
	$scriptName = $MyInvocation.MyCommand.Name
	Write-Host "usage: $scriptName <file>"
	exit 0
}

dumpbin($args[0])

