$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1

Add-Type -AssemblyName System.Web

function HttpGet( [string]$url )
{
	Write-Host "HTTP GET Request..."
	Write-Host "  url = $url"
	
	$httpWebReq = [Net.HttpWebRequest]::Create($url)
	$httpWebReq.KeepAlive = $true
	$httpWebReq.Timeout = 60000
	$httpWebReq.UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko)"
	$httpWebReq.Accept = "text/html,application/xhtml+xml,application/xml,*/*"
	
	$httpWebReq.Method = "GET"
	
	$response = $null
	
	try {
		[Net.HttpWebResponse]$response = $httpWebReq.GetResponse()
		$sr = New-Object IO.StreamReader($response.GetResponseStream(), $response.ContentEncoding)
		$content = $sr.ReadToEnd()
		Write-Host $content
		$sr.Close()
	}
	catch {
		$_
	}
	finally {
		if ( $response -ne $null ) { $response.Close() }
	}
}

$string = Read-Host "Please Enter GET keyword"
$word = [Web.HttpUtility]::UrlEncode($string)

HttpGet "http://www.google.co.jp/search?hl=ja&q=$word"
#HttpGet "http://localhost/search?hl=ja&q=$word"
