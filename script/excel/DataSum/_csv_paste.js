var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript( filespec )
{
	var csvPath = WScript.ScriptFullName.replace(WScript.ScriptName, "database.csv");
	var outPath = WScript.ScriptFullName.replace(WScript.ScriptName, "datasum.xlsx");
	
	if ( !fso.FileExists(csvPath) ) {
		LOG("[ERROR] file not found : " + csvPath);
		return 0;
	}
	if ( !fso.FileExists(outPath) ) {
		LOG("[ERROR] file not found : " + outPath);
		return 0;
	}
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	
	// ���ʃt�@�C����data�V�[�g��I��
	var objOutBook = objExcel.Workbooks.Open(outPath);
	var objOutSheet = objOutBook.WorkSheets("data");
	
	// csv��ǂݎ���p�ŊJ��
	var objCsvBook = objExcel.Workbooks.Open(csvPath, null, true);
	var objCsvSheet = objCsvBook.WorkSheets(1);
	
	// ���҂�
	objCsvSheet.Cells.Copy();
	objOutSheet.Cells.PasteSpecial();
	
	// �W�v�V�[�g��I��
	objOutBook.WorkSheets("aggrigate").Activate();
	
	// CSV�t�@�C�������
	objCsvBook.Close();
	
	// ���ʃt�@�C���̕ۑ�
	objOutBook.Save();
	objOutBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	return 0;
}


function LOG( str )
{
	WScript.Echo(str);
}
