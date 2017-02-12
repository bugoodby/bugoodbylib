$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0


function packbin( $file )
{
	$outPath = $file -Replace "\.[^\.]*$", ".bin"
	$sw = [IO.File]::OpenWrite($outPath)
	
	$sr = New-Object System.IO.StreamReader($file)

	while (($line = $sr.ReadLine()) -ne $null) {
		$a = $line -split ":"
		$s = $a[1].SubString(0, 48).Replace(' ', '')
		Write-Host $s
		$b = New-Object byte[] 0
		for ( $i = 0; $i -lt $s.length; $i += 2 ) {
			$b += [Convert]::ToByte($s.SubString($i, 2), 16)
		}
		$sw.Write($b, 0, $b.Length)
	}
	$sr.Close()
	$sw.Close()
}



if ($args.length -eq 0) {
	$scriptName = $MyInvocation.MyCommand.Name
	Write-Host "usage: $scriptName <file>"
	exit 0
}

packbin $args[0]

