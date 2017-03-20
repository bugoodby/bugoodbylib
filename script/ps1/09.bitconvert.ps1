$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'


function Convert-ValueToBytes( $type, $val )
{
	if ( $type -eq "i8" ) {
		$n = [sbyte]$val
		$ret = [byte](($n -band 0x7F) + ($n -band 0x80))
	}
	elseif ( $type -eq "u8" ) {
		$n = [byte]$val
		$ret = $n
	}
	elseif ( $type -eq "i16" ) {
		$n = [int16]$val
		$ret = [BitConverter]::GetBytes($n)
	}
	elseif ( $type -eq "u16" ) {
		$n = [uint16]$val
		$ret = [BitConverter]::GetBytes($n)
	}
	elseif ( $type -eq "i32" ) {
		$n = [int32]$val
		$ret = [BitConverter]::GetBytes($n)
	}
	elseif ( $type -eq "u32" ) {
		$n = [uint32]$val
		$ret = [BitConverter]::GetBytes($n)
	}
	elseif ( $type -eq "str" ) {
		$ret = [Text.Encoding]::ASCII.GetBytes($val)
	}
	else {
		$ret = $null
	}
	return $ret
}

function Convert-BytesToValue( $type, $bytes )
{
	$bytes = @($bytes)
	
	if ( $type -eq "i8" ) {
		$ret = [sbyte](($bytes[0] -band 0x7F) - ($bytes[0] -band 0x80))
	}
	elseif ( $type -eq "u8" ) {
		$ret = [byte]$bytes[0]
	}
	elseif ( $type -eq "i16" ) {
		$ret = [BitConverter]::ToInt16($bytes, 0)
	}
	elseif ( $type -eq "u16" ) {
		$ret = [BitConverter]::ToUint16($bytes, 0)
	}
	elseif ( $type -eq "i32" ) {
		$ret = [BitConverter]::ToInt32($bytes, 0)
	}
	elseif ( $type -eq "u32" ) {
		$ret = [BitConverter]::ToUint32($bytes, 0)
	}
	elseif ( $type -eq "str" ) {
		$ret = [Text.Encoding]::ASCII.GetString($bytes)
	}
	else {
		$ret = $null
	}
	return $ret
}

function check( $v, $b, $a )
{
	Write-Host ("{0} : {1}" -f $v.GetType().FullName, $v)
	Write-Host ("{0} : {1}" -f $a.GetType().FullName, $a)
	if ( $v -eq $a ) {
		Write-Host "OK"
	} else {
		Write-Host "**NG**"
		Read-Host ""
	}
}

for ( $i = -128; $i -le 127; $i++ ) {
	$b = Convert-ValueToBytes "i8" $i
	$a = Convert-BytesToValue "i8" $b
	check $i $b $a
}

$v = "-128"
$b = Convert-ValueToBytes "i8" $v
$a = Convert-BytesToValue "i8" $b
check $v $b $a

$v = "255"
$b = Convert-ValueToBytes "u8" $v
$a = Convert-BytesToValue "u8" $b
check $v $b $a

$v = "-32768"
$b = Convert-ValueToBytes "i16" $v
$a = Convert-BytesToValue "i16" $b
check $v $b $a

$v = "65535"
$b = Convert-ValueToBytes "u16" $v
$a = Convert-BytesToValue "u16" $b
check $v $b $a

$v = "-2147483648"
$b = Convert-ValueToBytes "i32" $v
$a = Convert-BytesToValue "i32" $b
check $v $b $a

$v = "4294967295"
$b = Convert-ValueToBytes "u32" $v
$a = Convert-BytesToValue "u32" $b
check $v $b $a

$v = "abcXYZ123 +-*/="
$b = Convert-ValueToBytes "str" $v
$a = Convert-BytesToValue "str" $b
check $v $b $a



