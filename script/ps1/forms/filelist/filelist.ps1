$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()


# returns System.IO.FileInfo[]

function ListFiles( $Path, $Include = "*" )
{
	return Get-ChildItem -Recurse -Include $Include $Path | ?{ ! $_.PSIsContainer }
}

function ListDirectories( $Path )
{
	return Get-ChildItem -Recurse $Path | ?{ $_.PSIsContainer }
}



# フォーム
$form = New-Object System.Windows.Forms.Form 
$form.Text = "FileList"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "WindowsDefaultLocation"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# テキストボックス
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 10)
$textBox.Size = New-Object System.Drawing.Size(470, 400)
$textBox.Text = ""
$textBox.MultiLine = $true
$textBox.ScrollBars = "Both"
$textBox.AcceptsReturn = $true
$textBox.AcceptsTab = $true
$textBox.WordWrap = $false

$form.Controls.Add($textBox)


$form.AllowDrop = $true
$form.Add_DragEnter({$_.Effect = 'Copy'})
$form.Add_DragDrop({
	$form.Cursor = "WaitCursor"
	$textBox.Text = ""
	foreach ( $fileName in $_.Data.GetData("FileDrop") ) {
		$textBox.Text += "<<<$fileName>>>`r`n"
		$files = ListFiles $fileName "*.txt"
		
		# ファイル名
#		$files | %{ $textBox.Text += "$_`r`n" }
		# フルパス
		$files | %{ $textBox.Text += [String]::Format("{0}`r`n", $_.FullName) }
	}
	$form.Cursor = "Default"
})


$form.ShowDialog()



