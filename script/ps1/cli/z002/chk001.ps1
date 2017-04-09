$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1

#-- XlDirection --
$xlUp      = -4162
$xlDown    = -4121
$xlToLeft  = -4159
$xlToRight = -4161
#-- XlBordersIndex --
$xlEdgeLeft         = 7
$xlEdgeTop          = 8
$xlEdgeBottom       = 9
$xlEdgeRight        = 10
$xlInsideVertical   = 11
$xlInsideHorizontal = 12
#-- XlLineStyle --
$xlContinuous = 1
$xlDash       = -4115
$xlDashDot    = 4
$xlDashDotDot = 5
$xlDot        = -4118
$xlDouble     = -4119
#-- XlBorderWeight --
$xlHairLine = 1
$xlThin     = 2
$xlThick    = 4
$xlMedium   = -4138
#-- XlCalculation --
$xlCalculationAutomatic = -4105
$xlCalculationManual = -4135
$xlCalculationSemiautomatic = 2


$CurrentTime = Get-Date -Format "yyyyMMdd_HHmmss"
$OutFile = $ScriptDir + $CurrentTime + ".txt"



$filters = @(
	@{ 'regexp' = "Hoge Start\( attr = (\d+), id = (.+), timing = (\d+), ptr = (.+)"; 'params' = @(1,2,3); },
	@{ 'regexp' = "Hoge End\( ret = (.+) \)"; 'params' = @(1); }
)


function setMatchData( $filter, $parts, $matches )
{
	Write-Host '------------------'
	Write-Host $parts[0]
	Write-Host $parts[1]
	Write-Host $parts[2]
	Write-Host $parts[3]
	Write-Host $parts[4]
	Write-Host $parts[5]
	foreach ( $i in $filter.params ) {
		Write-Host "Filter $i :" $matches[$i]
	}
}

function RGB( $red, $green, $blue )
{
	return (([uint32]$red) + ([uint32]$green * 256) + ([uint32]$blue * 65536) )
}

function AnalyzeLogFile( $objSheet, $startRow, $startCol )
{
	$row = $startRow

	$path = ($ScriptDir + "sample.txt")
	$encoding = New-Object System.Text.UTF8Encoding($false)
	$sr = New-Object System.IO.StreamReader($path, $encoding)
	
	while (($line = $sr.ReadLine()) -ne $null) {
		$parts = $line.split(":", 6)
		if ( $parts.length -ne 6 ) { continue }
		
		foreach ( $f in $filters ) {
			if ( $parts[5] -Match $f.regexp ) {
				setMatchData $f $parts $matches
				
				$col = $startCol
				for ( $i = 0; $i -lt 6; $i++ ) {
					$objSheet.Cells.Item($row, $col).Value2 = $parts[$i]
					$col++
				}
				foreach ( $i in $f.params ) {
					$objSheet.Cells.Item($row, $col).Value2 = $matches[$i]
					$col++
				}
				
				$row++
			}
		}
	}
	
	$sr.Close()
}

function main() 
{
	$path = $ScriptDir + "_result_chk001.xlsx"
	
	try {
		#-----------------------------------------------
		# Setup worksheet
		#-----------------------------------------------
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Add()
		$objSheet = $objBook.Worksheets.Item(1)
		
		$objSheet.Name = "from CSV"
		
		$row = 1
		$col = 1
		
		# ヘッダ作成
		$headerNames = @("time", "aaa", "bbb", "ccc", "ddd", "comment", "param1", "param2", "param3")
		foreach ( $h in $headerNames ) {
			$objSheet.Cells.Item($row, $col).Value2 = $h
			$col++
		}
		$row++
		
		#-----------------------------------------------
		# Write data to worksheet
		#-----------------------------------------------
		AnalyzeLogFile $objSheet $row 1
		
		#-----------------------------------------------
		# Teardown worksheet
		#-----------------------------------------------
		# テーブルの範囲確定
		$rt = $objSheet.UsedRange
		
		# テーブルに罫線描画
		$borders = @( $xlEdgeLeft, $xlEdgeRight, $xlEdgeTop, $xlEdgeBottom,
						$xlInsideVertical, $xlInsideHorizontal )
		foreach ( $b in $borders ) {
			$border = $rt.Borders.Item($b)
			$border.Weight = $xlThin
			$border.LineStyle = $xlContinuous
		}
		
		# ヘッダの範囲確定
		$firstCol = 1
		$lastCol = $objSheet.Cells.Item(1, $objSheet.Columns.Count).End($xlToLeft).Column
		$rs = $objSheet.Cells.Item(1, $firstCol).Address()
		$re = $objSheet.Cells.Item(1, $lastCol).Address()
		
		# ヘッダのカラーリング
		$objSheet.Range($rs, $re).Interior.Color = (RGB 253 233 217)
		
		# 列の幅を自動調整
		$objSheet.Range($rs, $re).EntireColumn.AutoFit() > $null
		
		# オートフィルタの設定
		$objSheet.Cells.Item(1, 1).EntireRow.AutoFilter() > $null
		
		# ウィンドウ枠の固定
		$objSheet.Cells.Item(2, 1).Select()
		$objExcel.ActiveWindow.FreezePanes = $true
		
		Write-Host "save:" $path
		$objBook.SaveAs($path)
		
		$objBook.Close()
		$objExcel.Quit()
	}
	finally {
		$objSheet = $null
		$objBook = $null
		$objExcel = $null
	}
}

main
