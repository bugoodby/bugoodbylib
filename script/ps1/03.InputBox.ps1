Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#---------------------------------------------
# InputBox
#---------------------------------------------
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

$str = [Microsoft.VisualBasic.Interaction]::InputBox("���b�Z�[�W", "�^�C�g��", "�����l")
if ( $str -eq "" ) {
	Write-Host "�����͂��L�����Z����������܂���"
} else {
	Write-Host $str
}

#---------------------------------------------
# MessageBox
#---------------------------------------------
Add-Type -Assembly System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��")

$ret = [System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "OKCancel")
if ( $ret -eq "OK" ) {
	Write-Host "OK���I������܂���"
} elseif ( $ret -eq "Cancel" ) {
	Write-Host "Cancel���I������܂���"
}

[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "YesNo")

[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "YesNoCancel")

