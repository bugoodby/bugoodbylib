[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()

$diffApp = "D:\\documents\\WinMergeU.exe"

$basedir = Split-Path -Path $MyInvocation.InvocationName -Parent
$defLeftPath = $basedir + "tmp_left.txt"
$defRightPath = $basedir + "tmp_right.txt"
$screenH = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height

$form = New-Object System.Windows.Forms.Form
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.Text = "diff"
$form.Width = 410
$form.Height = 210
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
$form.Location = New-Object System.Drawing.Point(10, ($screenH - $form.Height - 10))

$btnClrL = New-Object System.Windows.Forms.Button
$btnClrL.Location = New-Object System.Drawing.Point(5, 5)
$btnClrL.Text = "clear"
$btnClrL.add_Click({
	$textL.Text = ""
	$textL.ReadOnly = $false
})
$form.Controls.Add($btnClrL)

$btnClrR = New-Object System.Windows.Forms.Button
$btnClrR.Location = New-Object System.Drawing.Point(200, 5)
$btnClrR.Text = "clear"
$btnClrR.add_Click({
	$textR.Text = ""
	$textR.ReadOnly = $false
})
$form.Controls.Add($btnClrR)

$textL = New-Object System.Windows.Forms.TextBox
$textL.Location = New-Object System.Drawing.Point(5, ($btnClrL.Height + 10))
$textL.Size = New-Object System.Drawing.Size(190, 100)
$textL.Text = ""
$textL.MultiLine = $true
$form.Controls.Add($textL)

$textR = New-Object System.Windows.Forms.TextBox
$textR.Location = New-Object System.Drawing.Point(200, ($btnClrR.Height + 10))
$textR.Size = New-Object System.Drawing.Size(190, 100)
$textR.Text = ""
$textR.MultiLine = $true
$form.Controls.Add($textR)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(20, 140)
$button.Text = "比較"
$button.add_Click({
	$t1 = $textL.Text
	$t2 = $textR.Text
	if ( ($t1.lenght -eq 0) -or ($t2.length -eq 0) ) {
		[System.Windows.Forms.MessageBox]::Show("パスが未入力です")
		return
	}
	if ( -not (Test-Path $t1) ) {
		"$t1" | Out-File -FilePath $defLeftPath -Encoding UTF8
		$t1 = $defLeftPath
	}
	if ( -not (Test-Path $t2) ) {
		"$t2" | Out-File -FilePath $defRightPath -Encoding UTF8
		$t2 = $defRightPath
	}
	#[System.Windows.Forms.MessageBox]::Show("$diffApp `"$t1`" `"$t2`"" )
	Start-Process -FilePath "$diffApp" -ArgumentList "`"$t1`" `"$t2`"" 
})
$form.Controls.Add($button)

$btnSwap = New-Object System.Windows.Forms.Button
$btnSwap.Location = New-Object System.Drawing.Point(($button.Width + 40), 140)
$btnSwap.Text = "入替"
$btnSwap.add_Click({ 
	$tmp = $textR.Text
	$tmp_ro = $textR.ReadOnly
	$textR.Text = $textL.Text
	$textR.ReadOnly = $textL.ReadOnly
	$textL.Text = $tmp
	$textL.ReadOnly = $tmp_ro
})
$form.Controls.Add($btnSwap)

$btnClrA = New-Object System.Windows.Forms.Button
$btnClrA.Location = New-Object System.Drawing.Point(($button.Width + $btnSwap.Width + 60), 140)
$btnClrA.Text = "全クリア"
$btnClrA.add_Click({ 
	$textL.Text = ""
	$textL.ReadOnly = $false
	$textR.Text = ""
	$textR.ReadOnly = $false
})
$form.Controls.Add($btnClrA)

$form.AllowDrop = $true
$form.add_DragEnter({$_.Effect = 'Copy'})
$form.add_DragDrop({
	foreach ( $fileName in $_.Data.GetData("FileDrop") ) {
		if ( $textL.TextLength -eq 0 ) {
			$textL.Text = $fileName
			$textL.ReadOnly = $true
		}
		elseif ( $textR.TextLength -eq 0 ) {
			$textR.Text = $fileName
			$textR.ReadOnly = $true
		}
	}
})

foreach ( $a in $args ) {
	if ( $a.length -ne 0 ) {
		#Write-Host "$a"
		if ( $textL.TextLength -eq 0 ) {
			$textL.Text = $a
			$textL.ReadOnly = $true
		}
		elseif ( $textR.TextLength -eq 0 ) {
			$textR.Text = $a
			$textR.ReadOnly = $true
		}
	}
}

$form.ShowDialog()
