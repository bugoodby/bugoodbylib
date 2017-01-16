$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1


$form = New-Object System.Windows.Forms.Form 
$form.Text = "TextBox"
$form.Size = New-Object System.Drawing.Size(500,550)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(230,20)
$label.Text = "TextBox"

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, ($label.Bottom))
$textBox.Size = New-Object System.Drawing.Size(470, 350)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Both"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $true
$textBox.WordWrap = $false

$chkBox = New-Object System.Windows.Forms.CheckBox
$chkBox.Location = New-Object System.Drawing.Size(10,($textBox.Bottom+10)) 
$chkBox.Text = "check1" 

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, ($chkBox.Bottom+10))
$button.Size = New-Object System.Drawing.Size(75,25)
$button.Text = "button"
$button.Add_Click({
	if ( $chkBox.Checked ) {
		$textBox.Text += "checked: true`r`n"
	} else {
		$textBox.Text += "checked: false`r`n"
	}
})

$form.Controls.AddRange(@($label, $textBox, $chkBox, $button))

[void]$form.ShowDialog()



