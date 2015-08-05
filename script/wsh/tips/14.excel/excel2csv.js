var fso = new ActiveXObject("Scripting.FileSystemObject");

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
	// result�t�H���_�쐬
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
	if ( fso.FolderExists(resultDir) ) {
		LOG("[del] " + resultDir + "\\*");
		fso.DeleteFile(resultDir + "\\*", true);
	} else {
		LOG("[create] " + resultDir);
		fso.CreateFolder(resultDir);
	}
	
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\��
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	var objBook = objExcel.Workbooks.Open(filespec);
	
	var names = [];
	var objSheets = objBook.WorkSheets;
	var e = new Enumerator(objSheets);
	for ( ; !e.atEnd(); e.moveNext() ) {
		var sheet = e.item();
		names.push(sheet.Name);
	}
	
	for ( var i in names ) {
		var outfile = resultDir + i + ".csv";
		objSheets(names[i]).Activate();
		objBook.SaveAs(outfile, 6/*xlCSV*/);
	}
	
	objExcel.Quit();
	objExcel = null;
	return 0;
}


function LOG( str )
{
	WScript.Echo(str);
}
