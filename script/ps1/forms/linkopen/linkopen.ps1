$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()


function MainForm_Show()
{
	$form = New-Object System.Windows.Forms.Form 
	$form.Text = "LinkOpen"
	$form.Size = New-Object System.Drawing.Size(500,150)
	$form.StartPosition = "CenterScreen"
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
	$form.Font = New-Object System.Drawing.Font("", 9)

	$groupBox = New-Object System.Windows.Forms.GroupBox
	$groupBox.Location = New-Object System.Drawing.Size(10,10) 
	$groupBox.Size = New-Object System.Drawing.Size(450,100) 
	$groupBox.Text = "google:" 

	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,35)
	$label.Size = New-Object System.Drawing.Size(70,20)
	$label.Text = "Keyword:"

	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(($label.Right+10), 35)
	$textBox.Size = New-Object System.Drawing.Size(250, 30)
	$textBox.Text = ""
	$textBox.MultiLine = $false
	$textBox.ScrollBars = "None"
	$textBox.AcceptsReturn = $false
	$textBox.AcceptsTab = $false
	$textBox.WordWrap = $false
	$textBox.Add_KeyDown({
		$linklbl.Text = "https://www.google.co.jp/search?q=" + $textBox.Text.Trim()
	})
	
	$font = New-Object System.Drawing.Font("MS UI Gothic", 12)
	$textBox.Font = $font

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
	
	$linklbl = New-Object System.Windows.Forms.LinkLabel 
	$linklbl.Location = New-Object System.Drawing.Point(($textBox.Left), ($textBox.Bottom+10))
	$linklbl.Size = New-Object System.Drawing.Size(350,20) 
	$linklbl.Text = ""
	$linklbl.add_Click({
		[System.Diagnostics.Process]::Start($linklbl.Text)
	})
	
	$groupBox.Controls.AddRange(@($label,$textBox,$button,$linklbl))
	$form.Controls.Add($groupBox)

	[void]$form.ShowDialog()
}

MainForm_Show
