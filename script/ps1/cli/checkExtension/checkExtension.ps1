
function Check-Extension( $path )
{
	$ret = $false
	
	$ext = [IO.Path]::GetExtension($path)
	if ( ($ext -eq ".xls") `
		-or ($ext -eq ".xlsx") ) {
		$ret = $true
	}
	else {
		Add-Type -Assembly System.Windows.Forms
		$answer = [System.Windows.Forms.MessageBox]::Show("拡張子 $ext です。実行しますか？", "拡張子の確認", "YesNo")
		if ( $answer -eq "YES" ) { $ret = $true }
	}
	return $ret
}


$ret = Check-Extension $args[0]

$ret

