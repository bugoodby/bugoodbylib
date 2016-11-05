$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# �t�H�[��
$form = New-Object System.Windows.Forms.Form 
$form.Text = "EnvEdit"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

# �R���{�{�b�N�X
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

# �e�L�X�g�{�b�N�X
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(450, 350)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Vertical"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false

$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
$textBox.Text = $pathList -join "`r`n"

# �X�V�{�^��
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(40,400)
$OKButton.Size = New-Object System.Drawing.Size(75,30)
$OKButton.Text = "�X�V"
$OKButton.Add_Click({
	$form.Cursor = "WaitCursor"
	$pathStr = $textBox.Text.Replace("`r`n", ";")
	[environment]::SetEnvironmentVariable("Path", $pathStr, $Combo.Text)
	[System.Windows.Forms.MessageBox]::Show("���ϐ����X�V���܂���")
#	sleep -m 500
	$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
	$textBox.Text = $pathList -join "`r`n"
	$form.Cursor = "Default"
})

$form.Controls.Add($Combo)
$form.Controls.Add($textBox)
$form.Controls.Add($OKButton)


$form.ShowDialog()
