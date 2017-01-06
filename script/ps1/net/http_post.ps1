$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1


function HttpPost( [string]$url, [byte[]]$body )
{
	Write-Host "HTTP POST Request..."
	Write-Host "  url = $url"
	
	$httpWebReq = [Net.HttpWebRequest]::Create($url)
	$httpWebReq.ContentType = "text/html"
	$httpWebReq.ContentLength = $body.Length
	$httpWebReq.ServicePoint.Expect100Continue = $false
	$httpWebReq.KeepAlive = $false
	$httpWebReq.Timeout = 10000
	$httpWebReq.UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko)"
	$httpWebReq.Accept = "text/html,application/xhtml+xml,application/xml,*/*"
	
	$httpWebReq.Method = "POST"
	
	$request = $null
	$response = $null
	
	try {
		[IO.Stream]$request = $httpWebReq.GetRequestStream()
		[void]$request.Write($body, 0, $body.Length)
		
		[Net.HttpWebResponse]$response = $httpWebReq.GetResponse()
		Write-Host $response.StatusCode
	}
	catch {
		$_
	}
	finally {
		if ( $request -ne $null ) { $request.Close() }
		if ( $response -ne $null ) { $response.Close() }
	}
}

<#
### from console
$string = Read-Host "Please Enter POST String"
$bodyData = [Text.Encoding]::UTF8.GetBytes($string)
#>

### from text file
$path = $ScriptDir + "http_post.ps1"
$encoding = New-Object System.Text.UTF8Encoding($false)
$string = [IO.File]::ReadAllText($path, $encoding)
$bodyData = [Text.Encoding]::UTF8.GetBytes($string)

<#
### from binary file
$path = $ScriptDir + "http_post.ps1"
$bytes = [IO.File]::ReadAllBytes($path)
$base64 = [Convert]::ToBase64String( $bytes )
$base64mod = ""
for ( $i = 0; $i -lt $base64.Length; $i += 70 ) { 
	$size = ($base64.Length - $i)
	if ( $size -ge 70 ) { $size = 70 }
	$base64mod += $base64.SubString($i, $size)
	$base64mod += "`r`n"
}
$debugfile = ($ScriptDir + "debug.txt")
[IO.File]::WriteAllText($debugfile, $base64mod, [Text.Encoding]::ASCII)
$bodyData = [Text.Encoding]::UTF8.GetBytes($base64mod)
#>

HttpPost "http://localhost:80/" $bodyData

