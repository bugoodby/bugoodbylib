//------------------------------------------------
// Excel�萔
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
 
var xlWorkbookNormal		= -4143;
var xlNone 					= -1412;
 
//-- �\��t���Ώ� --
var xlPasteAll				= -4104;		//���ׂ�
var xlPasteFormulas			= -4123;		//����
var xlPasteValues			= -4163;		//�l
var xlPasteFormats			= -4122;		//����
var xlPasteComments			= -4144;		//�R�����g
var xlDataValidation		= 6;			//���͋K��
var xlPasteAllExceptBorders = 7;			//�r�����������ׂ�
var xlPasteColumnWidths 	= 8;			//��
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
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
	
	return ExecScript();
}

function ExecScript()
{
	Sample_ReadExcel();
	Sample_CreateExcel();
}

//----------------------------
// ��{�e�X�g
//----------------------------
function Sample_ReadExcel()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test1.xls");
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	var objBook = objExcel.Workbooks.Open(file);
	var objSheet = objBook.WorkSheets(1);
	
	LOG( "Text" );
	LOG( "  - Cells(7,4): " + objSheet.Cells(7,4).Text );
	LOG( "  - Range(D7)  : " + objSheet.Range("D7").Text );
	
	LOG( "Range <-> Cells" );
	LOG( "  - Range(D7) => Cells(" + objSheet.Range("D7").Row + "," + objSheet.Range("D7").Column + ")" );
	LOG( "  - Cells(7,4) => Range(" + objSheet.Cells(7,4).Address + ")" );
	
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
}

function Sample_CreateExcel()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test_created.xlsx");
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheet = objOutBook.WorkSheets(1);
	
	
	objOutSheet.Range("A1").Value = "�ق��ق�";
	objOutSheet.Cells(2, 2).Formula = "=1+1";
	
	
	// �o�̓t�@�C���̕ۑ�
	LOG("save: " + file);
	objOutBook.SaveAs(file);
	
	objOutBook.Close();
	
	objExcel.Quit();
	objExcel = null;
}

function LOG( str )
{
	WScript.Echo(str);
}
