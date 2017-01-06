$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1


function PackInteger( $val )
{
	$ary = [BitConverter]::GetBytes($val)
	[void][array]::Reverse($ary)
	return $ary
}

function PackString( $str, $size )
{
	$buf = [Text.Encoding]::UTF8.GetBytes($st.string)
	if ( $size -le $buf.Length ) {
		return $buf[0..($size-1)]
	}
	$padding = New-Object byte[] ($size - $buf.Length)
	return ($buf + $padding)
}

function PackPacket( $st )
{
	$buffer = [byte[]]$st.uint8
	$buffer += PackInteger $st.uint16
	$buffer += PackInteger $st.uint32
	$buffer += PackInteger $st.uint64
	$buffer += PackString $st.string 16
	$buffer += [byte]$st.bool
	
	hexdump $buffer
	return $buffer
}


function UdpSend( [string]$server, [string]$port, [byte[]]$body )
{
	Write-Host "TCP Send..."
	Write-Host "  server = $server, port = $port"
	
	$client = $null
	
	try {
		$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse($server), $port)
		$client = New-Object System.Net.Sockets.UdpClient
		[void]$client.Send($body, $body.Length, $endpoint)
	}
	catch {
		$_
	}
	finally {
		if ( $client -ne $null ) { $client.Close() }
	}
}



 
$struct = @{
	uint8 = [byte]0x12;
	uint16 = [uint16]0x3456;
	uint32 = [uint32]0x789ABCDE;
	uint64 = [uint64]0x123456789ABCDEF0;
	string = "hogehoge`r`n";
	bool = $true
}

$content = PackPacket $struct
UdpSend "127.0.0.1" "80" $content

