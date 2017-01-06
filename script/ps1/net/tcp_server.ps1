$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1

function dumpbin( [byte[]]$allData )
{
	$dumpLine = {
		PARAM([byte[]]$data)
		$line = ("{0:X8}: " -f $offset)
		$chars = ""
		foreach ($b in $data) {
			$line += ("{0:x2} " -f $b)
			if ($b -ge 0x20 -and $b -le 0x7e) {
				$chars += [char]$b
			} else {
				$chars += "."
			}
		}
		$line += "   " * (16 - $data.length)
		Write-Host $line, $chars
	}

	$offset = 0
	do {
		[byte[]]$ldata = $allData[$offset..($offset+15)]
		if ( $ldata.length -gt 0 ) {
			$dumpLine.Invoke($ldata)
		}
		$offset += 16
	} while ($ldata.length -gt 0)
}

function TcpServer ( [string]$port )
{
	$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, $port)
	$listener = New-Object System.Net.Sockets.TcpListener($endpoint)

	Write-Host "*********** tcp server start ($port) ***********"
	$listener.start()

	do {
		$client = $listener.AcceptTcpClient()
		Write-Host "<accept>====================="
		Write-Host "Connected from $($client.Client.RemoteEndPoint)"
		$buffer = New-Object byte[] $client.ReceiveBufferSize
		
		$stream = $client.GetStream()
		$reader = New-Object System.IO.StreamReader $stream
		do {
			$recvSize = $stream.Read($buffer, 0, $buffer.Length)
			if ( $recvSize -gt 0 ) {
				Write-Host "<recv:$recvSize>"
				dumpbin $buffer[0..($recvSize-1)]
			}
		} while ($recvSize -ne 0)
<#
			$line = $reader.ReadLine()
			if ( $line -ne $null ) {
				$bytes = [Text.Encoding]::ASCII.GetBytes($line)
				dumpbin $bytes
			}
		} while ($line -ne $null)
#>
		$reader.Close()
		$stream.Close()
		$client.Close()
		Write-Host "<close>====================="
	} while ( $true )
	
	$listener.stop()
}


TcpServer "80"
