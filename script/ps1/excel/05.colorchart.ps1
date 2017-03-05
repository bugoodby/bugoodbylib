$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

$xlUp      = -4162
$xlDown    = -4121
$xlToLeft  = -4159
$xlToRight = -4161


function RGB( $red, $green, $blue )
{
	return (([uint32]$red) + ([uint32]$green * 256) + ([uint32]$blue * 65536) )
}

function WriteExcel()
{
	$path = $ScriptDir + "_result_05.colorchart.xlsx"
	
	try {
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Add()
		$objSheet = $objBook.Worksheets.Item(1)
		
		$row = 1
		$col = 1
		
		for ( $r = 0; $r -le 255; $r += 0x33 ) {
			for ( $g = 0; $g -le 255; $g += 0x33 ) {
				for ( $b = 0; $b -le 255; $b += 0x33 ) {
					$objSheet.Cells.Item($row, $col) = "($r, $g, $b)"
					$objSheet.Cells.Item($row, $col).Interior.Color = (RGB $r $g $b)
					$row++
				}
			}
			$row = 1
			$col++
		}
		
		# —ñ‚Ì•‚ðŽ©“®’²®
		$lastCol = $objSheet.Cells.Item(1, $objSheet.Columns.Count).End($xlToLeft).Column
		for ( $i = 1; $i -le $lastCol; $i++ ) {
			$objSheet.Cells.Item(1, $i).EntireColumn.AutoFit() > $null
		}
		
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

