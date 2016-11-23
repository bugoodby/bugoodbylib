$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + "\\"

. ..\..\DebugTools.ps1
. .\subfunc.ps1


# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "pcapview"
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
#$form.Font = New-Object System.Drawing.Font("", 9)


# ツリー
$treeView = New-Object System.Windows.Forms.TreeView
$treeView.Location = New-Object System.Drawing.Point(10, 10)
$treeView.Size = New-Object System.Drawing.Size(200, 500)
$treeView.Add_AfterSelect({
	$textBox.Text = Dump-Block $treeView.SelectedNode.Tag
})
$treeView.Add_MouseDown({
	if ($_.Button -eq [Windows.Forms.MouseButtons]::Right) {
		$n = $treeView.GetNodeAt($_.X, $_.Y)
		if ( $n -ne $null ) {
			$treeView.selectedNode = $n
		}
	}
})
$contextMenu = New-object System.Windows.Forms.ContextMenuStrip
$treeView.ContextMenuStrip = $contextMenu
$contextMenuEdit = New-Object System.Windows.Forms.ToolStripMenuItem
$contextMenuEdit.Text = "Show Text"
[void]$contextMenu.Items.Add($contextMenuEdit)
$contextMenu.Add_Click({
	MsgBox $treeView.SelectedNode.Text
})


# テキストボックス
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(($TreeView.Right+10), $TreeView.Top)
$textBox.Size = New-Object System.Drawing.Size(550, 500)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Vertical"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false
$textBox.Font = New-Object System.Drawing.Font("ＭＳ ゴシック", 9)

$form.Controls.Add($treeView)
$form.Controls.Add($textBox)

# アンカー
$asTop = [System.Windows.Forms.AnchorStyles]::Top
$asBottom = [System.Windows.Forms.AnchorStyles]::Bottom
$asLeft = [System.Windows.Forms.AnchorStyles]::Left
$asRight = [System.Windows.Forms.AnchorStyles]::Right
$treeView.Anchor = $asTop -bor $asBottom -bor $asLeft
$textBox.Anchor = $asTop -bor $asBottom -bor $asLeft -bor $asRight

# ドラッグ＆ドロップ
$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	Refresh-TreeView $_.Data.GetData("FileDrop")[0]
})

$form.Showdialog()


