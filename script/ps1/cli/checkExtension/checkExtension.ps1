
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
		$answer = [System.Windows.Forms.MessageBox]::Show("�g���q $ext �ł��B���s���܂����H", "�g���q�̊m�F", "YesNo")
		if ( $answer -eq "YES" ) { $ret = $true }
	}
	return $ret
}


$ret = Check-Extension $args[0]

$ret

