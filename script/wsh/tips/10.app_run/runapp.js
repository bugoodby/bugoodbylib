
main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	// WScript�Ȃ�CScript�ŋN��������
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	runapp1();
	runapp2();
}

//-----------------------------------------------------
// object.Run(strCommand, [intWindowStyle], [bWaitOnReturn])
// 
//   strCommand     : ���s����R�}���h ���C��������������l
//   intWindowStyle : �v���O�����̃E�B���h�E�̊O��
//   bWaitOnReturn  : true - �v���O�������I������܂őҋ@���G���[�R�[�h��Ԃ�
//                    false - �����ɕ��A���Ď����I�� 0 ��Ԃ�
//-----------------------------------------------------
function runapp1()
{
	var wshShell = new ActiveXObject("WScript.Shell");
	
	//���������N��
	wshShell.Run("C:\\Windows\\System32\\notepad.exe", 1, false);
	
	wshShell.popup("���������N�����܂����B", 0);
}

//-----------------------------------------------------
// object.Exec(strCommand)
// 
//   strCommand : �X�N���v�g�̎��s�Ɏg�p����R�}���h ���C��������������l
//-----------------------------------------------------
function runapp2()
{
	var wshShell = new ActiveXObject("WScript.Shell");
	var cmd = "cmd.exe /c dir";
	
	//�R�}���h���s
	var oExec = wshShell.Exec(cmd);
	while ( oExec.Status == 0 ) {
		WScript.Sleep(100);
	}
	
	WScript.Echo("[StdOut]\n" + oExec.StdOut.ReadAll());
	WScript.Echo("[StdErr]\n" + oExec.StdErr.ReadAll());
}


