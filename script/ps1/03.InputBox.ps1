
#---------------------------------------------
# InputBox
#---------------------------------------------
#[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

$str = [Microsoft.VisualBasic.Interaction]::InputBox("���b�Z�[�W", "�^�C�g��")


#---------------------------------------------
# MessageBox
#---------------------------------------------
Add-Type -Assembly System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��")

$ret = [System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "OKCancel")
if ( $ret -eq "OK" ) {
	"OK���I������܂���"
} elseif ( $ret -eq "Cancel" ) {
	"Cancel���I������܂���"
}

[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "YesNo")

[System.Windows.Forms.MessageBox]::Show("�����Ƀ��b�Z�[�W", "�^�C�g��", "YesNoCancel")

