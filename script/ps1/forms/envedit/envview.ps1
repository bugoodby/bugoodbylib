$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# �t�H�[��
$form = New-Object System.Windows.Forms.Form 
$form.Text = "EnvView"
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

# ���x��
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(230,20)
$label.Text = "PATH"

# �R���{�{�b�N�X
$Combo = New-Object System.Windows.Forms.Combobox
$Combo.Location = New-Object System.Drawing.Point(10,30)
$Combo.size = New-Object System.Drawing.Size(150,30)
$Combo.DropDownStyle = "DropDownList"
[void] $Combo.Items.Add("Machine")
[void] $Combo.Items.Add("User")
[void] $Combo.Items.Add("Process")
$Combo.SelectedIndex = 0

$Combo.Add_SelectedIndexChanged({
	[void] $listBox.Items.Clear()
	$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
	foreach ( $item in $pathList ) {
		[void] $listBox.Items.Add($item)
	}
})

# OK�{�^��
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(240,230)
$OKButton.Size = New-Object System.Drawing.Size(75,30)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

# �L�����Z���{�^��
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(330,230)
$CancelButton.Size = New-Object System.Drawing.Size(75,30)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

# ���X�g�{�b�N�X
$listBox = New-Object System.Windows.Forms.ListBox 
$listBox.Location = New-Object System.Drawing.Point(10,60)
$listBox.Size = New-Object System.Drawing.Size(450,160)

$pathList = [environment]::GetEnvironmentVariable("Path", $Combo.Text) -split ";"
foreach ( $item in $pathList ) {
	[void] $listBox.Items.Add($item)
}

$form.Controls.Add($label)
$form.Controls.Add($Combo)
$form.Controls.Add($OKButton)
$form.Controls.Add($CancelButton)
$form.Controls.Add($listBox)

# �L�[�ƃ{�^���̊֘A�t��
$form.AcceptButton = $OKButton
$form.CancelButton = $CancelButton


$form.ShowDialog()
