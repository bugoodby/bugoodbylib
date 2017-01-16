$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1

$form = New-Object System.Windows.Forms.Form 
$form.Text = "StartProcess"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 10)
$textBox.Size = New-Object System.Drawing.Size(470, 400)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Both"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $true
$textBox.WordWrap = $false

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, ($textBox.Bottom+10))
$button.Size = New-Object System.Drawing.Size(75,25)
$button.Text = "Button"
$button.Add_Click({
	$textBox.Text += "start submodule`r`n"
	.\startprocess3_sub.ps1
	$textBox.Text += "ExitCode: $LastExitCode`r`n"
})

$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(($button.Right+10), ($textBox.Bottom+10))
$button2.Size = New-Object System.Drawing.Size(75,25)
$button2.Text = "Button2"
$button2.Add_Click({
	$textBox.Text += "start submodule`r`n"
	$proc = Start-Process -FilePath powershell -ArgumentList ".\startprocess3_sub.ps1" -Wait -PassThru
	$textBox.Text += "ExitCode: $($proc.ExitCode)`r`n"
})

$form.Controls.AddRange(@($textBox,$button,$button2))

[void]$form.ShowDialog()



