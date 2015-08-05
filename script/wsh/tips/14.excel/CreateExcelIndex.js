main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("�������s���ł�");
		return 1;
	}
	if ( !checkExtension(argv(0)) ) {
		return 1;
	}
	
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
	
	return ExecScript(argv(0));
}

function checkExtension( filespec )
{
	var ret = true;
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var ext = fso.GetExtensionName(filespec);
	
	switch ( ext ) {
	case "xls":
	case "xlsx":
		break;
	default:
		var wshShell = new ActiveXObject("WScript.Shell");
		var btn = wshShell.Popup("�g���q " + ext + " �ł��B���s���܂����H", 0, "invalid extension", 4/*MB_YESNO*/);
		if ( btn != 6/*IDYES*/ ) { ret = false; }
		break;
	}
	return ret;
}

function ExecScript( filespec )
{
	var Row_Header 		= 5;		//�w�b�_�̍s�ԍ�
	var Column_Count	= 2;		//�ԍ���\�������
	var Column_Link		= 3;		//�n�C�p�[�����N��\�������
	
	//------------------------------------------
	// excel �O����
	//------------------------------------------
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\��
	
	// Excel�t�@�C�����J��
	var objBook = objExcel.Workbooks.Open(filespec);
	
	//------------------------------------------
	// excel �{����
	//------------------------------------------
	var names = [];
	var objSheets = objBook.WorkSheets;
	var e = new Enumerator(objSheets);
	for ( ; !e.atEnd(); e.moveNext() ) {
		var sheet = e.item();
		names.push(sheet.Name);
	}
	
	var objIndexSheet = objSheets.Add(objSheets(1));
	objIndexSheet.Name = "�ڎ�";
	objIndexSheet.Cells(Row_Header, Column_Link).Value = "�����ڎ�����"
	
	var row = Row_Header + 1;
	for ( var i in names ) {
		WScript.Echo(i + " : " + names[i]);
		objIndexSheet.Cells(row + parseInt(i), Column_Count).Value = parseInt(i) + 1;
		objIndexSheet.Cells(row + parseInt(i), Column_Link).Formula = '=HYPERLINK("#\'' + names[i] + '\'!A1", "' + names[i] + '")';
	}
	
	//------------------------------------------
	// excel �㏈��
	//------------------------------------------
	// ��̕�����������
	for ( var i = Column_Count; i <= Column_Link; i++ ) {
		objIndexSheet.Cells(1, i).EntireColumn.AutoFit();
	}
	
	// �I�u�W�F�N�g�̔j��
	objExcel = null;
	
	WScript.Echo( "�ڎ��̍쐬���I�����܂����B" );
	return 0;
}


