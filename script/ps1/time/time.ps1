$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\DebugTools.ps1

$CurrentTime = Get-Date -Format "yyyyMMdd_HHmmss"
$OutFile = $ScriptDir + $CurrentTime + ".txt"

function getTime( $line ) {
	$str = "N/A"
	if ( $line -Match "^\s*([0-9\.]+):" ) {
		$str = $matches[1]
	}
	return $str
}

function toTime( $s, $ms, $us ) {
	$time = ([long]$s * 1000000) + ([long]$ms * 1000) + ([long]$us)
	return [long]$time
}

function getTimeDiff( $lineS, $lineE ) {
	$startTime = 0
	$endTime = 0
	
	if ( ($lineS -eq $null) -or ($lineE -eq $null) ) {
		return "N/A"
	}
	if ( $lineS -Match "^\s*(\d+)\.(\d+)\.(\d+):" ) {
		$startTime = toTime $matches[1] $matches[2] $matches[3]
	}
	if ( $lineE -Match "^\s*(\d+)\.(\d+)\.(\d+):" ) {
		$endTime = toTime $matches[1] $matches[2] $matches[3]
	}
	return ($endTime - $startTime)
}

#-----------
$docDataStore = @{}

function getDocData( $id ) {
	if ( $docDataStore.ContainsKey($id) ) {
		return $docDataStore[$id]
	}
	return $null
}

function setDocData( $id, $key, $val ) {
	if ( $docDataStore.ContainsKey($id) ) {
		$docDataStore[$id].Add($key, $val)
	} else {
		$newData = @{$key = $val}
		$docDataStore.Add($id, $newData)
	}
}

function printDocResult( $id ) {
	$print = {
		PARAM($docData, $start, $end)
		"   : {0, -10} - {1, -10} : {2, 15} - {3, 15} : {4, 10}" -f $start, $end, 
			(getTime $docData[$start]), (getTime $docData[$end]), 
			(getTimeDiff $docData[$start] $docData[$end]) | Out-File -Append $OutFile
	}
	$dd = $docDataStore[$id]
	if ( $dd -ne $null ) {
		$print.Invoke($dd, "POINT1", "POINT2")
		$print.Invoke($dd, "POINT3", "POINT4")
		$print.Invoke($dd, "hoge", "POINT2")
		$print.Invoke($dd, "POINT2", "POINT1")
	}
}

#-----------
$pageDataStore = @{}

function getPageData( $id, $num ) {
	if ( $pageDataStore.ContainsKey($id) ) {
		if ( $pageDataStore[$id].ContainsKey($num) ) {
			return $pageDataStore[$id][$num]
		}
	}
	return $null
}

function setPageData( $id, $num, $key, $val ) {
	if ( $pageDataStore.ContainsKey($id) ) {
		if ( $pageDataStore[$id].ContainsKey($num) ) {
			$pageDataStore[$id][$num].Add($key, $val)
		} else {
			$newData = @{$key = $val}
			$pageDataStore[$id].Add($num, $newData)
		}
	} else {
		$newData = @{$key = $val}
		$newPagesData = @{$num = $newData}
		$pageDataStore.Add($id, $newPagesData)
	}
}

function printPageResult( $id ) {
	$print = {
		PARAM($pageData, $num, $start, $end)
		"{0, 3}: {1, -10} - {2, -10} : {3, 15} - {4, 15} : {5, 10}" -f $num, $start, $end, 
			(getTime $pageData[$start]), (getTime $pageData[$end]), 
			(getTimeDiff $pageData[$start] $pageData[$end]) | Out-File -Append $OutFile
	}
	$pd = $pageDataStore[$id]
	if ( $pd -ne $null ) {
		$pd.Keys | % {
			$print.Invoke($pd[$_], $_, "POINT1", "POINT2")
		}
	}
}


#-----------

function outputResult() {
	$docDataStore.Keys | % {
		"[{0}]" -f $_ | Out-File -Append $OutFile
		printDocResult $_
		printPageResult $_
	}
}

function main() {
	$path = ($ScriptDir + "sample.txt")
	$encoding = New-Object System.Text.UTF8Encoding($false)
	$sr = New-Object System.IO.StreamReader($path, $encoding)
	
	while (($line = $sr.ReadLine()) -ne $null) {
		if ( $line -Match " POINT1" ) {
			setDocData "12345" "POINT1" $line
			setPageData "12345" "1" "POINT1" $line
		}
		elseif ( $line -Match " POINT2" ) {
			setDocData "12345" "POINT2" $line
			setPageData "12345" "1" "POINT2" $line
		}
		elseif ( $line -Match " POINT3" ) {
			setDocData "12345" "POINT3" $line
		}
		elseif ( $line -Match " POINT4" ) {
			setDocData "22456" "POINT4" $line
		}
		else {
			#ignore
		}
	}
	
	$sr.Close()
	
	outputResult
}

main
