var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("�������s���ł�");
		return 1;
	}
	
	// WScript�Ȃ�CScript�ŋN��������
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function ExecScript( filespec )
{
	// �o�̓t�H���_�쐬
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "source\\");
	if ( fso.FolderExists(resultDir) ) {
		LOG("[del] " + resultDir + "\\*");
		fso.DeleteFile(resultDir + "\\*", true);
	} else {
		LOG("[create] " + resultDir);
		fso.CreateFolder(resultDir);
	}
	
	//------------------------------------------
	// excel �O����
	//------------------------------------------
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = true;		// �A���[�g�ݒ�
	
	// Excel�t�@�C�����J��
	var objBook = objExcel.Workbooks.Open(filespec);
	
	//------------------------------------------
	// excel �{����
	//------------------------------------------
	var objProject = objBook.VBProject;
	var compCount = objProject.VBComponents.Count;
	
	for ( var i = 1; i <= compCount; ++i ) {
		type = objProject.VBComponents(i).Type;
		switch ( type ) {
		case 1:  ext = ".bas"; break;
		case 2:  ext = ".frm"; break;
		default: ext = ".cls"; break;
		}
		
		LOG("[" + i + "] " + objProject.VBComponents(i).Name + ext);
		out = resultDir + objProject.VBComponents(i).Name + ext;
		objProject.VBComponents(i).Export( out );
	}
	
	//------------------------------------------
	// excel �㏈��
	//------------------------------------------
	// �N���[�Y
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	return 0;
}

function LOG( str )
{
	WScript.Echo(str);
}

