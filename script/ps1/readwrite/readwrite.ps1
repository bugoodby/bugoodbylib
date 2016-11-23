$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

. ..\DebugTools.ps1


function read_sjis( $path )
{
	$str = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
	return $str
}

function read_utf8_bom( $path )
{
	$str = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
	return $str
}

function read_utf8( $path )
{
	$encoding = New-Object System.Text.UTF8Encoding($false)
	$str = [System.IO.File]::ReadAllText($path, $encoding)
	return $str
}

function write_default( $path )
{
	$str = "------`r`n"
	$str += "‚ ‚¢‚¤‚¦‚¨`r`n"
	$str += "‚©‚«‚­‚¯‚±`r`n"
	$str += "‚³‚µ‚·‚¹‚»`r`n"
	[System.IO.File]::WriteAllText($path, $str)
}

function write_sjis( $path )
{
	$str = "------`r`n"
	$str += "‚ ‚¢‚¤‚¦‚¨`r`n"
	$str += "‚©‚«‚­‚¯‚±`r`n"
	$str += "‚³‚µ‚·‚¹‚»`r`n"
	[System.IO.File]::WriteAllText($path, $str, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
}

function write_utf8_bom( $path )
{
	$str = "------`r`n"
	$str += "‚ ‚¢‚¤‚¦‚¨`r`n"
	$str += "‚©‚«‚­‚¯‚±`r`n"
	$str += "‚³‚µ‚·‚¹‚»`r`n"
	[System.IO.File]::WriteAllText($path, $str, [System.Text.Encoding]::UTF8)
}

function write_utf8( $path )
{
	$str = "------`r`n"
	$str += "‚ ‚¢‚¤‚¦‚¨`r`n"
	$str += "‚©‚«‚­‚¯‚±`r`n"
	$str += "‚³‚µ‚·‚¹‚»`r`n"
	$encoding = New-Object System.Text.UTF8Encoding($false)
	[System.IO.File]::WriteAllText($path, $str, $encoding)
}

function write_convert( $str )
{
	[System.IO.File]::WriteAllText(($ScriptDir + "OUT_sjis-sjis.txt"), $str, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
	$encoding = New-Object System.Text.UTF8Encoding($false)
	[System.IO.File]::WriteAllText(($ScriptDir + "OUT_sjis-utf8.txt"), $str, $encoding)
}


$sjisStr = read_sjis ($ScriptDir + "test_sjis.txt")
$utf8Str = read_utf8_bom ($ScriptDir + "test_utf8_bom.txt")
$utf8nStr = read_utf8 ($ScriptDir + "test_utf8.txt")

$sjisStr
$utf8Str
$utf8nStr

write_convert $sjisStr

write_default ($ScriptDir + "OUT_default.txt")
write_sjis ($ScriptDir + "OUT_sjis.txt")
write_utf8_bom ($ScriptDir + "OUT_utf8_bom.txt")
write_utf8 ($ScriptDir + "OUT_utf8.txt")




function readline_sjis( $path )
{
	"*** readline_sjis ***"
	$sr = New-Object System.IO.StreamReader($path, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
	while (($line = $sr.ReadLine()) -ne $null) {
		$line
	}
	$sr.Close()
}

function readline_utf8( $path )
{
	"*** readline_utf8 ***"
	$encoding = New-Object System.Text.UTF8Encoding($false)
	$sr = New-Object System.IO.StreamReader($path, $encoding)
	for ( $i = 0; ($line = $sr.ReadLine()) -ne $null; $i++ ) {
		"$i : $line"
	}
	$sr.Close()
}

readline_sjis ($ScriptDir + "test_sjis.txt")
readline_utf8 ($ScriptDir + "test_utf8.txt")
