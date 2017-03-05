$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

function WriteExcel()
{
	$path = $ScriptDir + "_result_02.Write.xlsx"
	
	try {
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Add()
		$objSheet = $objBook.Worksheets.Item(1)
		
		$objSheet.Cells.Item(2, 2) = "‚Ù‚°‚Ù‚°‚Ù‚°‚Ù‚°‚Ù‚°‚Ù‚°"
		$objSheet.Range("A1").Formula = "=1+1"
		$objSheet.Range("A2").Value2 = "‚Ó‚ª‚Ó‚ª"
		
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


WriteExcel

