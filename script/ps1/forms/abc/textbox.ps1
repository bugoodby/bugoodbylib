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

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(10,($textBox.Bottom+10)) 
$groupBox.Size = New-Object System.Drawing.Size(470,80) 
$groupBox.Text = "option:" 

$radio1 = New-Object System.Windows.Forms.RadioButton
$radio1.Location = New-Object System.Drawing.Point(15,15)
$radio1.size = New-Object System.Drawing.Size(80,30)
$radio1.Checked = $True
$radio1.Text = "File"

$radio2 = New-Object System.Windows.Forms.RadioButton
$radio2.Location = New-Object System.Drawing.Point(($radio1.Right+10),15)
$radio2.size = New-Object System.Drawing.Size(80,30)
$radio2.Text = "Directory"

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(10, ($radio1.Bottom+5))
$textBox2.Size = New-Object System.Drawing.Size(200,30)
$textBox2.Text = ""
$textBox2.MultiLine = $false
$textBox2.ScrollBars = "None"
$textBox2.AcceptsReturn = $false
$textBox2.AcceptsTab = $false
$textBox2.WordWrap = $false

$groupBox.Controls.AddRange(@($radio1, $radio2, $textBox2))
$form.Controls.AddRange(@($label, $textBox, $groupBox))

$asTop = [System.Windows.Forms.AnchorStyles]::Top
$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
$asLeft = [System.Windows.Forms.AnchorStyles]::Left
$asRight = [System.Windows.Forms.AnchorStyles]::Right
$textBox.Anchor = $asTop -bor $asBottom -bor $asLeft -bor $asRight

$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	$form.Cursor = "WaitCursor"
	$textBox.Text = ""
	foreach ( $path in $_.Data.GetData("FileDrop") ) {
		if ( $radio2.Checked ) {
			$files = Get-ChildItem -Recurse -LiteralPath $path | ?{ $_.PSIsContainer }
		} else {
			$files = Get-ChildItem -Recurse -LiteralPath $path | ?{ ! $_.PSIsContainer } | ?{ $_.Name -match $textBox2.Text }
		}
		
		$textBox.Text += "<<<$path>>>`r`n"
#		$files | %{ $textBox.Text += "$_`r`n" }
		$files | %{ $textBox.Text += ("{0}`r`n" -f $_.FullName) }
	}
	$form.Cursor = "Default"
})

[void]$form.ShowDialog()



