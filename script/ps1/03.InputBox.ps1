
#---------------------------------------------
# InputBox
#---------------------------------------------
#[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

$str = [Microsoft.VisualBasic.Interaction]::InputBox("メッセージ", "タイトル")


#---------------------------------------------
# MessageBox
#---------------------------------------------
Add-Type -Assembly System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル")

$ret = [System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "OKCancel")
if ( $ret -eq "OK" ) {
	"OKが選択されました"
} elseif ( $ret -eq "Cancel" ) {
	"Cancelが選択されました"
}

[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "YesNo")

[System.Windows.Forms.MessageBox]::Show("ここにメッセージ", "タイトル", "YesNoCancel")

