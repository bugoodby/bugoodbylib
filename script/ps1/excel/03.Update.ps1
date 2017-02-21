$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

function UpdateExcel( [string]$path )
{
	try {
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Open($path, $null, $false)
		$objSheet = $objBook.Worksheets.Item("Sheet2")
		
		$objSheet.Cells.Item(1, 1).Value2 = "‚Ù‚°‚Ù‚°"
		$objSheet.Range("A2").Value2 = "‚Ó‚ª‚Ó‚ª"
		
		Write-Host "save"
		$objBook.Save()
		
		$objBook.Close()
		$objExcel.Quit()
	}
	finally {
		$objSheet = $null
		$objBook = $null
		$objExcel = $null
	}
}

$srcPath = $ScriptDir + "test1.xlsx"
$dstPath = $ScriptDir + "test1_copy.xlsx"
Copy-Item -LiteralPath $srcPath -Destination $dstPath

UpdateExcel $dstPath

