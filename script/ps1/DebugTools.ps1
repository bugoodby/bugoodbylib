Add-Type -AssemblyName System.Windows.Forms

function Load-Ini( $Path )
{
	$inidata = @{}
	if ( Test-Path $Path ) {
		$lines = Get-Content $Path
		foreach ( $l in $lines ) {
			if ( $l -match "^;"){ continue }
			$p = $l.split("=", 2)
			if ( $p.length -eq 2 ) { $inidata.Add($p[0].Trim(), $p[1].Trim()) }
		}
	}
	return $inidata
}

function Save-Ini( $Path, $IniData )
{
	$text = ""
	foreach ( $k in $IniData.Keys ) {
		$text += ( "$k=" + $IniData[$k] + "`r`n" )
	}
	[IO.File]::WriteAllText($Path, $text, [Text.Encoding]::GetEncoding("Shift_JIS"))
	return
}

function breakpoint()
{
	Write-Host '------[EnterNestedPrompt]-------'
	Write-Host 'Get-Variable : Show variables.'
	Write-Host 'PSCallStack : Show callstack.'
	Write-Host '$xxx | Out-GridView : Show variable with gridview.'
	Write-Host 'HexDump: 16進数ダンプ'
	Write-Host 'HexDumpWin: 16進数ダンプ(ウィンドウ表示)'
	Write-Host 'ShowPG: PropetyGrid表示'
	Write-Host '--------------------------------'
	
	$host.EnterNestedPrompt()
}

function MsgBox( [string]$str )
{
	[System.Windows.Forms.MessageBox]::Show($str, "debug")
}

function hexdump( [byte[]]$allData )
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

	Write-Host "(Len: $($allData.Length))"
	$offset = 0
	do {
		[byte[]]$ldata = $allData[$offset..($offset+15)]
		if ( $ldata.length -gt 0 ) {
			$dumpLine.Invoke($ldata)
		}
		$offset += 16
	} while ($ldata.length -gt 0)
}

function HexDumpWin( [byte[]]$obj )
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
		return "$line $chars`r`n"
	}

	$form = New-Object System.Windows.Forms.Form 
	$form.Size = "500,200"
	$form.Text = "HexDump"
	$tb = New-Object System.Windows.Forms.TextBox
	$tb.Text = ""
	$tb.MultiLine = $true
	$tb.ScrollBars = "Both"
	$tb.Dock = "Fill"
	$tb.Font = New-Object System.Drawing.Font("ＭＳ ゴシック", 9)
	$form.Controls.Add($tb)

	$offset = 0
	do {
		[byte[]]$ldata = $obj[$offset..($offset+15)]
		if ( $ldata.length -gt 0 ) {
			$tb.Text += $dumpLine.Invoke($ldata)
		}
		$offset += 16
	} while ($ldata.length -gt 0)

	[void]$form.ShowDialog()
	return
}

function ShowObj( $obj )
{
	if ($obj -ne $null) {
		$str = "[FullName]`r`n"
		$str += ($obj.GetType().FullName + "`r`n")
		$str += "[BaseType]`r`n"
		$str += ($obj.GetType().BaseType.FullName + "`r`n`r`n")
		
		if ( $obj -is [array] ) {
			$str += ("[Length: " + $obj.Length + "]`r`n")
			$obj | %{ $str += ($_.toString() + "`r`n") }
		}
		elseif ( $obj -is [hashtable] ) {
			$str += ("[Count: " + $obj.Count + "]`r`n")
			foreach ( $k in $obj.Keys ) {
				$str += ("{0} : {1}`r`n" -f $k, $obj[$k])
			}
		}
		else {
			$str += $obj.toString()
		}
	} else {
		$str = "null"
	}
	$form = New-Object System.Windows.Forms.Form 
	$form.Size = "400,200"
	$form.Text = "ShowObj"
	$tb = New-Object System.Windows.Forms.TextBox
	$tb.Text = $str
	$tb.MultiLine = $true
	$tb.ScrollBars = "Both"
	$tb.ReadOnly = $true
	$tb.Dock = "Fill"
	$tb.Font = New-Object System.Drawing.Font("ＭＳ ゴシック", 9)
	$form.Controls.Add($tb)
	[void]$form.ShowDialog()
	return
}

function ShowPG( $obj )
{
	$form = New-Object System.Windows.Forms.Form 
	$form.Size = "600,600"
	$pg = New-Object System.Windows.Forms.PropertyGrid
	$pg.Dock = "Fill"
	$form.Controls.Add($pg)
	if ($obj -ne $null) {
		$pg.SelectedObject = $obj.PSObject.BaseObject
		$form.Text = [string]::Format("Property - {0}", $obj.toString())
    }
	[void]$form.ShowDialog()
	return
}
