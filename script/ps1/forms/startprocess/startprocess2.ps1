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
	$pi = New-Object System.Diagnostics.ProcessStartInfo
	$pi.FileName = "cmd.exe"
	$pi.RedirectStandardError = $true
	$pi.RedirectStandardOutput = $true
	$pi.UseShellExecute = $false
	$pi.Arguments = "/c ruby -e `"puts 'hogehoge'`""
	$p = New-Object System.Diagnostics.Process
	$p.StartInfo = $pi
	$p.Start() | Out-Null
	$p.WaitForExit()
	$stdout = $p.StandardOutput.ReadToEnd()
	$stderr = $p.StandardError.ReadToEnd()
	$textBox.Text = "[StdOut]`r`n$stdout"
	$textBox.Text += "[StdErr]`r`n$stderr"
})

$form.Controls.AddRange(@($textBox,$button))

$form.ShowDialog()



