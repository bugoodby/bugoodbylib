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

function UdpServer ( [string]$port )
{
	$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, $port)
	$server = New-Object System.Net.Sockets.UdpClient($port)

	Write-Host "*********** udp server start ($port) ***********"

	do {
		$content = $server.Receive([ref]$endpoint)
		Write-Host "<recv:$($content.Length)>"
		dumpbin $content
	} while ( $true )
	
	$server.Close()
}


UdpServer "80"
