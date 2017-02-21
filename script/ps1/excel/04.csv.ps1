$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

function ReadCSV( $path )
{
	$tblHeader = @{}
	$tblData = @()
	
	$enc = [Text.Encoding]::GetEncoding("Shift_JIS")
	$sr = New-Object System.IO.StreamReader($path, $enc)
	
	while (($line = $sr.ReadLine()) -ne $null) {
		if ( $line.Contains("タイトル行") ) {
			Write-Host "HEADER FOUND"
			$items = $line.Split(",")
			for ( $i = 0; $i -lt $items.Length; $i++ ) {
				$tblHeader[$items[$i]] = $i
			}
			break
		}
	}
	while (($line = $sr.ReadLine()) -ne $null) {
		$items = $line.Split(",")
		$tblData += ,$items
	}
	
	$sr.Close()
	$sr = $null
	
	return @{ "Header" = $tblHeader; "Data" = $tblData; }
}


$tbl = ReadCSV ($ScriptDir + "database.csv")

$tbl.Header
$tbl.Data.Length

