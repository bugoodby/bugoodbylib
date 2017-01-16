$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. .\DebugTools.ps1

Write-Host "--------------------------------------------"
Write-Host "array"
Write-Host "--------------------------------------------"

Write-Host "******************"

function Create-Array1()
{
	$ary = @()
	$ary += "aaa"
	return $ary # System.String!!!
}

$a1 = Create-Array1
$a1.GetType().FullName
$a1
$a1 = @($a1) # convert to Object[]
$a1.GetType().FullName
$a1

Write-Host "******************"

function Create-Array2()
{
	$ary = @()
	$ary += "aaa"
	$ary += "bbb"
	return $ary
}

$a2 = Create-Array2
$a2.GetType().FullName
$a2
#$a2 = @($a1) # nop
#$a2.GetType().FullName
#$a2

Write-Host "******************"

function func{
	Write-Host "---func---"
	$args.Length
	$args | %{
		$_.GetType().FullName
		$_.Length
		Write-Host $_
	}
}

$block = {
	PARAM([array]$ary)
	Write-Host "---block---"
	$ary.GetType().FullName
	$ary.Length
	Write-Host $ary
}

func $a1 $a2
& $block $a2


Write-Host "--------------------------------------------"
Write-Host "hash"
Write-Host "--------------------------------------------"
function Create-Hash1()
{
	$ary = @{}
	$ary.Add( "aaa", "value - aaa" )
	return $ary
}

function Create-Hash2()
{
	$ary = @{}
	$ary.Add( "aaa", "value - aaa" )
	$ary.Add( "bbb", "value - bbb" )
	return $ary
}

function Create-Hash3()
{
	$ary = @{}
	$ary["aaa"] = "value - aaa"
	$ary["bbb"] = "value - bbb"
	return $ary
}

Write-Host "******************"
$h1 = Create-Hash1
$h1.GetType().FullName
$h1

Write-Host "******************"
$h2 = Create-Hash2
$h2.GetType().FullName
$h2

Write-Host "******************"
$h3 = Create-Hash3
$h3.GetType().FullName
$h3

