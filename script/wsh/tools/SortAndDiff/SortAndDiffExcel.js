//------------------------------------------------
// ���[�U�[�ݒ�l
//------------------------------------------------
var HEADER_ROW = 2;			// �w�b�_�̍s�ԍ�
var LEFTLIST_COL = 2;		// �����񃊃X�g(��)�������o����ԍ�
var RIGHTLIST_COL = 3;		// �����񃊃X�g(�E)�������o����ԍ�

//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 2 ) {
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
		//cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0), argv(1));
}

function ExecScript( filespecL, filespecR )
{
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	// Excel�萔
	var xlWorkbookNormal		= -4143;
	
	//------------------------------------------
	// ���͍��
	//------------------------------------------
	// �����񃊃X�g���쐬
	var aryL = ReadStringArray(filespecL);
	var aryR = ReadStringArray(filespecR);
	
	var countL = aryL.length;
	var countR = aryR.length;
	
	// �����񃊃X�g���\�[�g
	aryL.sort();
	aryR.sort();
	
	//------------------------------------------
	// �o�͍��
	//------------------------------------------
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	// �o�̓t�@�C����V�K�쐬
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheet = objOutBook.Worksheets(1);
	objOutSheet.Select();
	
	// �w�b�_�̍쐬
	objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).Value = fso.GetFileName(filespecL) + " : " + countL;
	objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).Interior.Color = RGB(192,192,192);
	objOutSheet.Cells(HEADER_ROW, RIGHTLIST_COL).Value = fso.GetFileName(filespecR) + " : " + countR;
	objOutSheet.Cells(HEADER_ROW, RIGHTLIST_COL).Interior.Color = RGB(192,192,192);
	
	// ���X�g��r���ʂ̍쐬
	var i = HEADER_ROW + 1;
	var l = 0, r = 0;
	
	while ( (l < countL) && (r < countR) ) {
		if ( aryL[l] == aryR[r] ) {
			WScript.Echo(i + ": " + aryL[l] + " | " + aryR[r]);
			objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
			objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
			l++;
			r++;
		}
		else if ( aryL[l] < aryR[r] ) {
			WScript.Echo(i + ": " + aryL[l] + " | ");
			objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
			objOutSheet.Cells(i, LEFTLIST_COL).Interior.Color = RGB(255,255,0);
			l++;
		}
		else {
			WScript.Echo(i + ":  | " + aryR[r]);
			objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
			objOutSheet.Cells(i, RIGHTLIST_COL).Interior.Color = RGB(255,255,0);
			r++;
		}
		i++;
	}
	
	while ( l < countL ) {
		WScript.Echo(i + ": " + aryL[l] + " | ");
		objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
		objOutSheet.Cells(i, LEFTLIST_COL).Interior.Color = RGB(255,255,0);
		l++;
		i++;
	}
	while ( r < countR ) {
		WScript.Echo(i + ":  | " + aryR[r]);
		objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
		objOutSheet.Cells(i, RIGHTLIST_COL).Interior.Color = RGB(255,255,0);
		r++;
		i++;
	}
	
	// ��̕�����������
	objOutSheet.Cells(1, LEFTLIST_COL).EntireColumn.AutoFit();
	objOutSheet.Cells(1, RIGHTLIST_COL).EntireColumn.AutoFit();
	
	// �I�[�g�t�B���^�̐ݒ�
	rs = objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).address;
	re = objOutSheet.Cells(i, RIGHTLIST_COL).address;
	objOutSheet.Range(rs, re).AutoFilter();
	
	// �o�̓t�@�C���̕ۑ�
	var outXlsPath = WScript.ScriptFullName.replace(WScript.ScriptName, "diff_result.xls");
    objOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
	
	// �N���[�Y
	//objOutBook.Close();
	//objExcel.Quit();
	
	// �I�u�W�F�N�g�̔j��
	objExcel = null;
	
	return 0;
}

function ReadStringArray( filespec )
{
	var lines = [];
	
	// �t�@�C���̑��݃`�F�b�N
	if ( !fso.FileExists(filespec) ) {
		WScript.Echo("[ERROR] " + filespec + " �����݂��܂���");
		return lines;
	}
	
	// �e�L�X�g��ǂݍ���ōs���Ƃɔz��
	var rs = fso.OpenTextFile(filespec, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	lines = text.split("\r\n");
	
	// ������̑O��̋󔒂�����
	for ( var i in lines ) {
		lines[i] = lines[i].replace(/^\s+|\s+$/g, "");
	}
	return lines;
}

