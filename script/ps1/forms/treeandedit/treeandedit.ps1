$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$ScriptDir = (Split-Path -Path $MyInvocation.InvocationName -Parent) + "\\"


. .\subfunc.ps1


# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "Tree & Edit"
$form.Size = New-Object System.Drawing.Size(500,300)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable


# ツリー
$treeView = New-Object System.Windows.Forms.TreeView
$treeView.Location = "10,10"
$treeView.Size = "150,200"
$treeView.Add_AfterSelect({
	$textBox.Text += $treeView.SelectedNode.Tag
	$textBox.Text += "`r`n"
})
$a = $treeView.Nodes.Add("test")
$a.Tag = "abc", 234, 'b'

$imglist = new-object System.Windows.Forms.ImageList
$imglist.ImageSize = New-Object System.Drawing.Size(16,16)
$imglist.Images.Add([Drawing.Image]::FromFile(($ScriptDir + "bitmap1.bmp")))
$treeView.ImageList = $imglist

# テキストボックス
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(($TreeView.Right+10), $TreeView.Top)
$textBox.Size = New-Object System.Drawing.Size(300, 200)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Vertical"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $false
$textBox.WordWrap = $false



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


