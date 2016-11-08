$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "StartProcess"
$form.Size = New-Object System.Drawing.Size(500,150)
$form.StartPosition = "WindowsDefaultLocation"
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
