$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'

$xlUp      = -4162
$xlDown    = -4121
$xlToLeft  = -4159
$xlToRight = -4161
#-- �r���̈ʒu --
$xlEdgeLeft         = 7
$xlEdgeTop          = 8
$xlEdgeBottom       = 9
$xlEdgeRight        = 10
$xlInsideVertical   = 11
$xlInsideHorizontal = 12
#-- �r���̎�� --
$xlContinuous = 1
$xlDash       = -4115
$xlDashDot    = 4
$xlDashDotDot = 5
$xlDot        = -4118
$xlDouble     = -4119
#-- �r���̑��� --
$xlHairLine = 1
$xlThin     = 2
$xlThick    = 4
$xlMedium   = -4138


function ReadCSV( $path )
{
	$tblHeader = @{}
	$tblData = @()
	
	$enc = [Text.Encoding]::GetEncoding("Shift_JIS")
	$sr = New-Object System.IO.StreamReader($path, $enc)
	
	while (($line = $sr.ReadLine()) -ne $null) {
		if ( $line.Contains("�^�C�g���s") ) {
			Write-Host "HEADER FOUND"
			$items = $line.Split(",")
			for ( $i = 0; $i -lt $items.Length; $i++ ) {
				$tblHeader[$items[$i]] = $i
			}
			break
		}
	}
	while (($line = $sr.ReadLine()) -ne $null) {
		$items = $line.Split(",")
		$tblData += ,$items
	}
	
	$sr.Close()
	$sr = $null
	
	return @{ "Header" = $tblHeader; "Data" = $tblData; }
}

function RGB( $red, $green, $blue )
{
	return (([uint32]$red) + ([uint32]$green * 256) + ([uint32]$blue * 65536) )
}

function WriteExcel( $tbl )
{
	$path = $ScriptDir + "_result_04.csv.xlsx"
	
	try {
		$objExcel = New-Object -ComObject Excel.Application
		$objExcel.Visible = $true
		$objExcel.DisplayAlerts = $false
		
		$objBook = $objExcel.Workbooks.Add()
		$objSheet = $objBook.Worksheets.Item(1)
		
		$objSheet.Name = "from CSV"
		
		$row = 1
		$col = 1
		
		# �w�b�_�쐬
		$h_order = $tbl.Header.GetEnumerator() | sort -Property Value
		foreach ( $de in $h_order ) {
			$objSheet.Cells.Item($row, $col).Value2 = $de.Name
			$col++
		}
		$row++
		
		# �f�[�^�쐬
		foreach ( $record in $tbl.Data ) {
			if ( $record[$tbl.Header['ID']] -eq "A02" ) {
				$col = 1
				foreach ($item in $record) {
					$objSheet.Cells.Item($row, $col).Value2 = $item
					$col++
				}
				$row++
			}
		}
		
		# �e�[�u���͈̔͊m��
		$rt = $objSheet.UsedRange
		
		# �e�[�u���Ɍr���`��
		$borders = @( $xlEdgeLeft, $xlEdgeRight, $xlEdgeTop, $xlEdgeBottom,
						$xlInsideVertical, $xlInsideHorizontal )
		foreach ( $b in $borders ) {
			$border = $rt.Borders.Item($b)
			$border.Weight = $xlThin
			$border.LineStyle = $xlContinuous
		}
		
		# �w�b�_�͈̔͊m��
		$firstCol = 1
		$lastCol = $objSheet.Cells.Item(1, $objSheet.Columns.Count).End($xlToLeft).Column
		$rs = $objSheet.Cells.Item(1, $firstCol).Address()
		$re = $objSheet.Cells.Item(1, $lastCol).Address()
		
		# �w�b�_�̃J���[�����O
		$objSheet.Range($rs, $re).Interior.Color = (RGB 253 233 217)
		
		# ��̕�����������
		$objSheet.Range($rs, $re).EntireColumn.AutoFit() > $null
		$objSheet.Cells.Item(1, 1).ColumnWidth = 15  # �ʐݒ�
		
		# �I�[�g�t�B���^�̐ݒ�
		$objSheet.Cells.Item(1, 1).EntireRow.AutoFilter() > $null
		
		# �E�B���h�E�g�̌Œ�
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



$tbl = ReadCSV ($ScriptDir + "database.csv")

$tbl.Header


WriteExcel $tbl

