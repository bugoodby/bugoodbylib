$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
#$host.EnterNestedPrompt()

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + '\'
. ..\..\DebugTools.ps1


$form = New-Object System.Windows.Forms.Form 
$form.Text = "test"
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.Font = New-Object System.Drawing.Font("", 9)
$form.Icon = $Icon

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(600,20)
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
		"menu 1" { $listView.SelectedItems | %{ $listView.Items.Remove($_) } }
		"menu 2" { $listView.SelectedItems | %{
			$str = ""
			for ( $i = 0; $i -lt $listView.Columns.Count; $i++ ) {
				$str += ("{0}: {1}`r`n" -f $listView.Columns[$i].Text, $_.SubItems[$i].Text)
			}
			[System.Windows.Forms.MessageBox]::Show($str, "Title")
		}
	}
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

$asTop = [System.Windows.Forms.AnchorStyles]::Top
$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
$asLeft = [System.Windows.Forms.AnchorStyles]::Left
$asRight = [System.Windows.Forms.AnchorStyles]::Right
$listView.Anchor = $asTop -bor $asBottom -bor $asLeft -bor $asRight
$button.Anchor = $asBottom -bor $asLeft

$AddFiles = {
	PARAM([string]$path)
	
	$label.Text = $path
	
	Get-ChildItem -Recurse -LiteralPath $path | ?{ !$_.PSIsContainer } | %{
		$item = New-Object System.Windows.Forms.ListViewItem($_.Name)
		$item.UseItemStyleForSubItems = $false
		[void]$item.SubItems.Add($_.Extension)
		$si = $item.SubItems.Add($_.Length)
		$si.ForeColor = [Drawing.Color]::White
		$si.BackColor = [Drawing.Color]::Red
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
	foreach ( $path in $_.Data.GetFileDropList() ) {
		$AddFiles.Invoke($path)
	}
	$form.Cursor = "Default"
})

[void]$form.ShowDialog()

