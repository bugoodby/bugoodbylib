$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

function Get-InputString1()
{
	$input = Read-Host "Input string"
	if ( $input -eq "" ) { break }
	Write-Host "INPUT:" $input
}

function Get-InputString2()
{
	$list = @( "One", "Two", "Three", "four", "five" )
	for ( $i = 0; $i -lt $list.Length; ++$i ) {
		Write-Host "$($i+1) : $($list[$i])"
	}
	Write-Host "q : quit"
	
	$input = Read-Host "Select number"
	if ( $input -eq "q" ) { 
		exit 1
	}
	Write-Host $input
	
	$num = [int]$input - 1
	if ( $num -lt 0 -or $num -ge $list.Length ) {
		Write-Host "[ERROR] Invalid range."
		exit 1
	}

	Write-Host $list[$num]
}

function Get-InputString3()
{
	$list = @()
	$path = $ScriptDir + '08.list.txt'
	$enc = New-Object System.Text.UTF8Encoding($false)
	$sr = New-Object System.IO.StreamReader($path, $enc)
	while (($line = $sr.ReadLine()) -ne $null) {
		if ( $line -match "^#"){ continue }
		if ( $line.Trim().Length -eq 0 ) { continue }
		$list += $line.Trim()
	}
	
	for ( $i = 0; $i -lt $list.Length; ++$i ) {
		Write-Host "$($i+1) : $($list[$i])"
	}
	Write-Host "q : quit"
	
	$input = Read-Host "Select number"
	if ( $input -eq "q" ) { 
		exit 1
	}
	$num = [int]$input - 1
	if ( $num -lt 0 -or $num -ge $list.Length ) {
		Write-Host "[ERROR] Invalid range."
		exit 1
	}

	Write-Host $list[$num]
}


while($true)
{
	Get-InputString3
	
	$answer = Read-Host "Repeat? (y/n)"
	if ( $answer -ne "y" ) {
		break
	}
}
