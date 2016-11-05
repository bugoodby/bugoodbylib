$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "LinkOpen"
$form.Size = New-Object System.Drawing.Size(500,150)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

# グループボックス
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(10,10) 
$groupBox.Size = New-Object System.Drawing.Size(450,100) 
$groupBox.Text = "google:" 

# テキストボックス
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(300, 30)
$textBox.Text = ""
$textBox.MultiLine = $false
$textBox.ScrollBars = "None"
$textBox.AcceptsReturn = $false
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false

$font = New-Object System.Drawing.Font($textBox.Font.SystemFontName, 13)
#$font = New-Object System.Drawing.Font("MS UI Gothic", 13)
$textBox.Font = $font


# ボタン
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(($textBox.Right + 10), $textBox.Top)
$button.Size = New-Object System.Drawing.Size(75,25)
$button.Text = "Go"
$button.Add_Click({
	$instr = $textBox.Text.Trim()
	if ( $instr.length -eq 0 ) {
		[System.Windows.Forms.MessageBox]::Show("Error", "LinkOpen")
	} else {
		$url = "https://www.google.co.jp/search?q=" + $instr
		Start-Process -FilePath $url
	}
})


$groupBox.Controls.Add($textBox)
$groupBox.Controls.Add($button)
$form.Controls.Add($groupBox)


$form.ShowDialog()
