$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1

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


do {
	$string = Read-Host "Please Enter String"
	$bodyData = [Text.Encoding]::UTF8.GetBytes($string)

	UdpSend "127.0.0.1" "80" $bodyData
} while($true)
