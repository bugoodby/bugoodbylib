var str = "";

// �����̎擾
str += "[Arguments]\n";
str += "count : " + WScript.Arguments.Count() + "\n";
for ( var i = 0; i < WScript.Arguments.Count(); i++ ) {
	str += "arg(" + i + ") : " + WScript.Arguments(i) + "\n";
}
str += "\n";

// �e��v���p�e�B�̎擾
str += "[Data]\n"
str += "Version        : " + WScript.Version + "\n";
str += "Name           : " + WScript.Name + "\n";
str += "Path           : " + WScript.Path + "\n";
str += "FullName       : " + WScript.FullName + "\n";
str += "Interactive    : " + WScript.Interactive + "\n";
str += "ScriptFullName : " + WScript.ScriptFullName + "\n";
str += "ScriptName     : " + WScript.ScriptName + "\n";
str += "ScriptPath     : " + WScript.ScriptFullName.replace(WScript.ScriptName, "") + "\n";
str += "\n";

// �_�C�A���O �{�b�N�X�܂��̓R���\�[���ɏo��
WScript.Echo(str);

// �X�N���v�g�̃v���Z�X���~���b�Ŏw�肳�ꂽ����������A�N�e�B�u�ɂ�����A���s���ĊJ
WScript.Sleep(100);

// ���s�̏I��
WScript.Quit(0);

