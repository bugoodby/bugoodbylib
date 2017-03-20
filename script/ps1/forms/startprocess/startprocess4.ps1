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
	$form.Text = "test"
	$form.Size = New-Object System.Drawing.Size(500,600)
	$form.StartPosition = "WindowsDefaultLocation"
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
	$form.Font = New-Object System.Drawing.Font("", 9)

	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,10)
	$label.Size = New-Object System.Drawing.Size(230,20)
	$label.Text = "List"

	$listView = New-Object System.Windows.Forms.ListView
	$listView.Location = New-Object System.Drawing.Point(10,($label.Bottom+5))
	$listView.Size = New-Object System.Drawing.Size(450,160)
	$listView.View = "Details"
	$listView.GridLines = $true
	$listView.FullRowSelect = $true
	$listView.MultiSelect = $false
	$listView.HideSelection = $false
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

	$button2 = New-Object System.Windows.Forms.Button
	$button2.Location = New-Object System.Drawing.Point(($button.Right+10), ($listView.Bottom+10))
	$button2.Size = New-Object System.Drawing.Size(75,25)
	$button2.Text = "Button2"
	$button2.Add_Click({
		if ( $listView.SelectedItems.Count -eq 0 ) {
			[System.Windows.Forms.MessageBox]::Show("Please select from list.", "Title")
		} else {
<#
			$textBox.Text += "start submodule`r`n"
			$proc = Start-Process -FilePath powershell -ArgumentList ".\startprocess3_sub.ps1" -Wait -PassThru
			$textBox.Text += "ExitCode: $($proc.ExitCode)`r`n"
#>
			$pi = New-Object System.Diagnostics.ProcessStartInfo
			$pi.FileName = "cmd.exe"
			$pi.WorkingDirectory = $ScriptDir
			$pi.RedirectStandardError = $true
			$pi.RedirectStandardOutput = $true
			$pi.UseShellExecute = $false
			$pi.Arguments = "/c $($listView.SelectedItems[0].SubItems[0].Text)"
			$p = New-Object System.Diagnostics.Process
			$p.StartInfo = $pi
			$p.Start() > $null
			$p.WaitForExit()
			$stdout = $p.StandardOutput.ReadToEnd()
			$stderr = $p.StandardError.ReadToEnd()
			$textBox.Text = "[ExitCode]`r`n$($p.ExitCode)`r`n"
			$textBox.Text += "[StdOut]`r`n$stdout"
			$textBox.Text += "[StdErr]`r`n$stderr"
		}
	})

	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10, ($button.Bottom+10))
	$textBox.Size = New-Object System.Drawing.Size(450, 200)
	$textBox.Text = ""
	$textBox.MultiLine = $true
	$textBox.ScrollBars = "Both"
	$textBox.AcceptsReturn = $true
	$textBox.AcceptsTab = $true
	$textBox.WordWrap = $true
	$textBox.Font = New-Object System.Drawing.Font("Consolas", 9)

	$form.Controls.AddRange(@($label, $listView, $button, $button2, $textBox))

	$asTop = [System.Windows.Forms.AnchorStyles]::Top
	$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
	$asLeft = [System.Windows.Forms.AnchorStyles]::Left
	$asRight = [System.Windows.Forms.AnchorStyles]::Right
	$listView.Anchor = $asTop -bor $asBottom -bor $asLeft -bor $asRight
	$button.Anchor = $asBottom -bor $asLeft
	$button2.Anchor = $asBottom -bor $asLeft
	$textBox.Anchor = $asBottom -bor $asLeft

	$AddFiles = {
		PARAM([string]$path)
		Get-ChildItem -Recurse -LiteralPath $path | ?{ !$_.PSIsContainer } | %{
			$item = New-Object System.Windows.Forms.ListViewItem($_.Name)
			$item.UseItemStyleForSubItems = $false
			[void]$item.SubItems.Add($_.Extension)
			[void]$item.SubItems.Add($_.Length)
			[void]$item.SubItems.Add($_.LastWriteTime.toString())
			[void]$item.SubItems.Add($_.FullName)
			[void]$listView.Items.Add($item)
		}
		return
	}

	& $AddFiles $ScriptDir

	$form.AllowDrop = $true
	$form.Add_DragEnter({$_.Effect = 'Copy'})
	$form.Add_DragDrop({
		$form.Cursor = "WaitCursor"
		foreach ( $path in $_.Data.GetData("FileDrop") ) {
			$AddFiles.Invoke($path)
		}
		$form.Cursor = "Default"
	})

	[void]$form.ShowDialog()
}

MainForm_Show

