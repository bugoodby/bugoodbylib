$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1


$struct = @{
	uint8 = [byte]0;
	uint16 = [uint16]0;
	uint32 = [uint32]0;
	uint64 = [uint64]0;
	string = "";
	bool = $false
}

function Unpack-Uint16( [byte[]]$buf )
{
	[void][array]::Reverse($buf)
	$ret = [System.BitConverter]::ToUint16($buf, 0)
	return $ret
}
function Unpack-Uint32( [byte[]]$buf )
{
	[void][array]::Reverse($buf)
	$ret = [System.BitConverter]::ToUint32($buf, 0)
	return $ret
}
function Unpack-Uint64( [byte[]]$buf )
{
	[void][array]::Reverse($buf)
	$ret = [System.BitConverter]::ToUint64($buf, 0)
	return $ret
}

function Unpack-Content( [byte[]]$buf )
{
	$enc_utf8 = New-Object System.Text.UTF8Encoding($false)
	
	$struct.uint8 = $buf[0]
	$struct.uint16 = Unpack-Uint16 $buf[1..2]
	$struct.uint32 = Unpack-Uint32 $buf[3..6]
	$struct.uint64 = Unpack-Uint64 $buf[7..14]
	$struct.string = $enc_utf8.GetString( $buf[15..30] )
	$struct.bool = [bool]$buf[31]
	
	Write-Host "$$struct"
	Write-Host ("  .uint8  = 0x{0:x2}" -f $struct.uint8)
	Write-Host ("  .uint16 = 0x{0:x4}" -f $struct.uint16)
	Write-Host ("  .uint32 = 0x{0:x8}" -f $struct.uint32)
	Write-Host ("  .uint64 = 0x{0:x16}" -f $struct.uint64)
	Write-Host ("  .string = {0}" -f $struct.string)
	Write-Host ("  .bool   = {0}" -f $struct.bool)
	
}

function UdpServer ( [string]$port )
{
	$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, $port)
	$server = New-Object System.Net.Sockets.UdpClient($port)

	Write-Host "*********** udp server start ($port) ***********"

	do {
		$content = $server.Receive([ref]$endpoint)
		Write-Host "<recv:$($content.Length)>"
		
		Unpack-Content $content
		
	} while ( $true )
	
	$server.Close()
}


UdpServer "80"
