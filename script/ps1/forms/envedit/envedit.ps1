$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form 
$form.Text = "EnvEdit"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

$Combo = New-Object System.Windows.Forms.Combobox
$Combo.Location = New-Object System.Drawing.Point(10,10)
$Combo.size = New-Object System.Drawing.Size(150,30)
$Combo.DropDownStyle = "DropDownList"
[void] $Combo.Items.Add("Machine")
[void] $Combo.Items.Add("User")
[void] $Combo.Items.Add("Process")
$Combo.SelectedIndex = 0
$Combo.Add_SelectedIndexChanged({
	$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
	$textBox.Text = $pathList -join "`r`n"
})

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(450, 350)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Vertical"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false
$textBox.Font = New-Object System.Drawing.Font("ＭＳ ゴシック", 10)

$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
$textBox.Text = $pathList -join "`r`n"

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(40,400)
$button.Size = New-Object System.Drawing.Size(75,30)
$button.Text = "更新"
$button.Add_Click({
	$form.Cursor = "WaitCursor"
	$pathStr = $textBox.Text.Replace("`r`n", ";")
	[environment]::SetEnvironmentVariable("Path", $pathStr, $Combo.Text)
	[System.Windows.Forms.MessageBox]::Show("環境変数を更新しました")
#	sleep -m 500
	$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
	$textBox.Text = $pathList -join "`r`n"
	$form.Cursor = "Default"
})

$form.Controls.Add($Combo)
$form.Controls.Add($textBox)
$form.Controls.Add($button)


$form.ShowDialog()
