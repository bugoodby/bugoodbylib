$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

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
		$text += ( "$k=" + $IniData[$k] + "`n" )
	}
	[IO.File]::WriteAllText($Path, $text)
}

$basedir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + "\\"
$ini = Load-Ini -Path ($basedir + "config.ini")
if ( -not $ini["width"] ) { $ini.Add("width", 500) }
if ( -not $ini["height"] ) { $ini.Add("height", 150) }


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "StartProcess"
$form.Size = New-Object System.Drawing.Size($ini["width"], $ini["height"])
#$form.StartPosition = "WindowsDefaultLocation"
$form.StartPosition = "Manual"
$form.Location = New-Object System.Drawing.Point($ini["posx"], $ini["posy"])
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

# ラベル
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(230,20)
$label.Text = "Data Path:"

# テキストボックス
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, ($label.Bottom))
$textBox.Size = New-Object System.Drawing.Size(($form.ClientSize.Width-20), 30)
$textBox.Text = ""
$textBox.MultiLine = $false
$textBox.ScrollBars = "None"
$textBox.AcceptsReturn = $false
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false

# ボタン
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, ($textBox.Bottom+10))
$button.Size = New-Object System.Drawing.Size(75,25)
$button.Text = "Go"
$button.Add_Click({
	$instr = $textBox.Text.Trim()
	if ( $instr.length -eq 0 ) {
		[System.Windows.Forms.MessageBox]::Show("Error", "StartProcess")
	} else {
		Start-Process -FilePath $instr
	}
})


$form.Controls.Add($label)
$form.Controls.Add($textBox)
$form.Controls.Add($button)

# アンカー
$asTop = [System.Windows.Forms.AnchorStyles]::Top
$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
$asLeft = [System.Windows.Forms.AnchorStyles]::Left
$asRight = [System.Windows.Forms.AnchorStyles]::Right
$textBox.Anchor = $asTop -bor $asLeft -bor $asRight

# ドラッグ＆ドロップ
$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	foreach ( $dropPath in $_.Data.GetData("FileDrop") ) {
		$files = Get-ChildItem $dropPath | ?{ ! $_.PSIsContainer }
		$files | %{
			if ( $_.Extension -eq ".txt" ) {
				$textBox.Text = $_.FullName
			}
		}
	}
})

$form.ShowDialog()

$ini["posx"] = $form.Left
$ini["posy"] = $form.Top
$ini["width"] = $form.Width
$ini["height"] = $form.Height
Save-Ini -Path ($basedir + "config.ini") -IniData $ini
