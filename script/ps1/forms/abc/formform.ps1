$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$isDraggable = $false
$orgPoint = New-Object System.Drawing.Point(0, 0)

function Add-MouseEvent( $control )
{
	$control.Add_MouseDown({
		$isDraggable = $true
		$orgPoint.X = $this.Left - $_.X
		$orgPoint.Y = $this.Top - $_.Y
	})
	$control.Add_MouseUp({
		$isDraggable = $false
		$this.Left = $orgPoint.X + $_.X
		$this.Top = $orgPoint.Y + $_.Y
	})
	return
}

function Add-TextBox( $form )
{
	$base = 0
	$form.Controls | % { if ( $_.Bottom -gt $base ) { $base = $_.Bottom } }

	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10,($base+10))
	$textBox.Size = New-Object System.Drawing.Size(200, 100)
	$textBox.Text = ""
	$textBox.MultiLine = $true
	$textBox.ScrollBars = "Vertical"
	$textBox.AcceptsReturn = $true
	$textBox.AcceptsTab = $false
	$textBox.WordWrap = $false
	$textBox.Font = New-Object System.Drawing.Font("ÇlÇr ÉSÉVÉbÉN", 10)

	Add-MouseEvent $textBox
	$form.Controls.Add($textBox)
	return
}

function Add-Button( $form )
{
	$base = 0
	$form.Controls | % { if ( $_.Bottom -gt $base ) { $base = $_.Bottom } }

	$button = New-Object System.Windows.Forms.Button
	$button.Location = New-Object System.Drawing.Point(10,($base+10))
	$button.Size = New-Object System.Drawing.Size(75,30)
	$button.Text = "button"

	Add-MouseEvent $button
	$form.Controls.Add($button)
	return
}

$form = New-Object System.Windows.Forms.Form 
$form.Text = "test"
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.Font = New-Object System.Drawing.Font("", 9)

Add-TextBox $form
Add-Button $form

[void]$form.ShowDialog()

