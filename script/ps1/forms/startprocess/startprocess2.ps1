$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1


function MainForm_Show()
{
	$form = New-Object System.Windows.Forms.Form 
	$form.Text = "StartProcess"
	$form.Size = New-Object System.Drawing.Size(500,500)
	$form.StartPosition = "WindowsDefaultLocation"
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
	$form.Font = New-Object System.Drawing.Font("", 9)

	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10, 10)
	$textBox.Size = New-Object System.Drawing.Size(470, 400)
	$textBox.Text = ""
	$textBox.MultiLine = $true
	$textBox.ScrollBars = "Both"
	$textBox.AcceptsReturn = $true
	$textBox.AcceptsTab = $true
	$textBox.WordWrap = $true
	$textBox.Font = New-Object System.Drawing.Font("Consolas", 9)

	$button = New-Object System.Windows.Forms.Button
	$button.Location = New-Object System.Drawing.Point(10, ($textBox.Bottom+10))
	$button.Size = New-Object System.Drawing.Size(75,25)
	$button.Text = "Button"
	$button.Add_Click({
		$pi = New-Object System.Diagnostics.ProcessStartInfo
		$pi.FileName = "cmd.exe"
		$pi.WorkingDirectory = $ScriptDir
		$pi.RedirectStandardError = $true
		$pi.RedirectStandardOutput = $true
		$pi.UseShellExecute = $false
		$pi.Arguments = "/c cd && ruby -e `"puts 'hogehoge'; puts 'piyopiyo'; exit 3`""
		$p = New-Object System.Diagnostics.Process
		$p.StartInfo = $pi
		$p.Start() | Out-Null
		$p.WaitForExit()
		$stdout = $p.StandardOutput.ReadToEnd()
		$stderr = $p.StandardError.ReadToEnd()
		$textBox.Text = "[ExitCode]`r`n$($p.ExitCode)`r`n"
		$textBox.Text += "[StdOut]`r`n$stdout"
		$textBox.Text += "[StdErr]`r`n$stderr"
	})

	$asTop = [System.Windows.Forms.AnchorStyles]::Top
	$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
	$asLeft = [System.Windows.Forms.AnchorStyles]::Left
	$asRight = [System.Windows.Forms.AnchorStyles]::Right
	$textBox.Anchor = $asTop -bor $asLeft -bor $asRight

	$form.Controls.AddRange(@($textBox,$button))

	[void]$form.ShowDialog()
}

MainForm_Show


