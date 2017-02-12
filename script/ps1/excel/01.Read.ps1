$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'


$xlUp      = -4162
$xlDown    = -4121
$xlToLeft  = -4159
$xlToRight = -4161



function ReadExcel()
{
	$path = $ScriptDir + "test1.xlsx"
	
	try {
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Open($path, $null, $true)
		$objSheet = $objBook.Worksheets.Item(1)
		
		#----------------------------
		# Cells, Range
		#----------------------------
		Write-Host "Text"
		Write-Host "  - Cells(6,3): " $objSheet.Cells.Item(6,3).Text
		Write-Host "  - Range(C6): " $objSheet.Range("C6").Text
		
		Write-Host "Rnage <-> Cells"
		$row = $objSheet.Range("C6").Row
		$col = $objSheet.Range("C6").Column
		Write-Host "  - Range(C6) => Cells(" $row "," $col ")"
		$addr = $objSheet.Cells.Item(7,4).Address()
		Write-Host "  - Cells(6,3) => Range(" $addr ")"
		
		
		#----------------------------
		# 最終セル
		#----------------------------
		$baseCell = "B5"
		$lastRow = $objSheet.Cells.Item($objSheet.Rows.Count, $objSheet.Range($baseCell).Column).End($xlUp).Row
		$lastCol = $objSheet.Cells.Item($objSheet.Range($baseCell).Row, $objSheet.Columns.Count).End($xlToLeft).Column
		Write-Host "last = (" $lastRow "," $lastCol ")"
		
		#----------------------------
		# シート一覧
		#----------------------------
		Write-Host "シート数:" $objBook.WorkSheets.Count
		foreach ( $sheet in $objBook.WorkSheets ) {
			Write-Host "[" $sheet.Name "]"
		}
		
		$objBook.Close()
		$objExcel.Quit()
	}
	finally {
		$objSheet = $null
		$objBook = $null
		$objExcel = $null
	}
}


ReadExcel

