var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
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
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function checkExtension( filespec )
{
	var ret = true;
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
	var org_path = WScript.ScriptFullName.replace(WScript.ScriptName, "test_orgdata.xls");
	var sheet_name = "URL_List";
	
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	// ���f�[�^�t�@�C����ǂݎ���p�ŊJ��
	var oOrgBook = objExcel.Workbooks.Open(org_path, null, true);
	var oOrgSheet = oOrgBook.WorkSheets(sheet_name);
	if ( !oOrgSheet ) {
		LOG("ERROR : �V�[�g������܂��� (" + sheet_name + ")");
		return 1;
	}
	
	// Excel�t�@�C�����J��
	var objBook = objExcel.Workbooks.Open(filespec);
	
	// �ΏۃV�[�g���擾
	var objTargetSheet = objBook.WorkSheets(sheet_name);
	if ( !objTargetSheet ) {
		LOG("ERROR : �V�[�g������܂��� (" + sheet_name + ")");
		return 1;
	}
	
	oOrgSheet.Cells.Copy();
	objTargetSheet.Cells.PasteSpecial();
	
	// �ۑ�
	objBook.Save();
	
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
