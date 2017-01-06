$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1

function TcpSend( [string]$server, [string]$port, [byte[]]$body )
{
	Write-Host "TCP Send..."
	Write-Host "  server = $server, port = $port"
	
	$client = $null
	$stream = $null
	
	try {
		$client = New-Object System.Net.Sockets.TCPClient
		$client.Connect($server, $port);
		$stream = $client.GetStream()
		[void]$stream.Write($body, 0, $body.Length)
	}
	catch {
		$_
	}
	finally {
		if ( $stream -ne $null ) { $stream.Close() }
		if ( $client -ne $null ) { $client.Close() }
	}
}

do {
	$string = Read-Host "Please Enter String"
	$bodyData = [Text.Encoding]::UTF8.GetBytes($string)
	
	TcpSend "127.0.0.1" "80" $bodyData
} while ($true)

