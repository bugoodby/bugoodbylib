$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form 
$form.Text = "test"
$form.Size = New-Object System.Drawing.Size(500,350)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(230,20)
$label.Text = "List"

$listView = New-Object System.Windows.Forms.ListView
$listView.Location = New-Object System.Drawing.Point(10,($label.Bottom+10))
$listView.Size = New-Object System.Drawing.Size(450,160)
$listView.View = "Details"
$listView.GridLines = $true
$listView.FullRowSelect = $true
$listView.MultiSelect = $true
$listView.CheckBoxes = $true
[void]$listView.Columns.Add("Name", 100)
[void]$listView.Columns.Add("Extension", 50)
[void]$listView.Columns.Add("Size", 100)
[void]$listView.Columns.Add("LastWriteTime", 100)
[void]$listView.Columns.Add("Path", 500)

$contextMenu = New-object System.Windows.Forms.ContextMenuStrip
$listView.ContextMenuStrip = $contextMenu
$contextMenu1 = New-Object System.Windows.Forms.ToolStripMenuItem
$contextMenu1.Text = "menu 1"
$contextMenu2 = New-Object System.Windows.Forms.ToolStripMenuItem
$contextMenu2.Text = "menu 2"
[void]$contextMenu.Items.Add($contextMenu1)
[void]$contextMenu.Items.Add($contextMenu2)
$contextMenu.Add_ItemClicked({
	switch($_.ClickedItem.Text) {
	"menu 1" { $listView.SelectedItems | % { $listView.Items.Remove($_) } }
	default { }
	}
})
$contextMenu.Add_Opening({
	if ($listView.SelectedItems.Count -le 0) { $_.Cancel = $true; }
})

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,($listView.Bottom+10))
$button.Size = New-Object System.Drawing.Size(75,30)
$button.Text = "clear"
$button.Add_Click({
	$listView.Items.Clear()
})

$form.Controls.AddRange(@($label, $listView, $button))

$AddFiles = {
	PARAM([string]$path)
	Get-ChildItem -Recurse $path | ?{ !$_.PSIsContainer } | %{
		$item = New-Object System.Windows.Forms.ListViewItem($_.Name)
		[void]$item.SubItems.Add($_.Extension)
		[void]$item.SubItems.Add($_.Length)
		[void]$item.SubItems.Add($_.LastWriteTime.toString())
		[void]$item.SubItems.Add($_.FullName)
		[void]$listView.Items.Add($item)
	}
	return
}

$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	$form.Cursor = "WaitCursor"
	foreach ( $path in $_.Data.GetData("FileDrop") ) {
		$AddFiles.Invoke($path)
	}
	$form.Cursor = "Default"
})

$form.ShowDialog()

