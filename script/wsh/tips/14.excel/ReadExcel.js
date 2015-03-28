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


//-----------------------------------------------------------
// DebugUtil v4
//-----------------------------------------------------------
var DebugUtil={c:true,f:false,ws:null,
	Init: function(target){this.c=true; this.f=false;
		if(target=="both"){this.f=true;} else if(target=="file"){this.c=false;this.f=true;}
		if(this.f){var fso=new ActiveXObject("Scripting.FileSystemObject");
		this.ws=fso.OpenTextFile(WScript.ScriptFullName.replace(WScript.ScriptName, "debuglog.txt"),8,true,0);
		this.ws.WriteLine("\n\n\n[[[LOG START: "+new Date()+" ]]]\n"); fso=null;}},
	Term: function(){if(this.f){this.ws.Close(); this.ws=null;}}
};
function LOG(str){
	if(DebugUtil.f){DebugUtil.ws.WriteLine(str);} if(DebugUtil.c){WScript.StdOut.WriteLine(str);}
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
//-----------------------------------------------------------
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
	DebugUtil.Init("both");
	
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
	LOG("�V�[�g���F" + objBook.WorkSheets.Count);
	
	var e = new Enumerator( objBook.WorkSheets );
	for ( ; !e.atEnd(); e.moveNext() ) {
		var sheet = e.item();
		
		LOG("-----------------------------------------");
		LOG("[" + sheet.Name + "]");
		
		// 1��ڂ̍Ō�̍s�A1�s�ڂ̍Ō�̗���擾
		//var lastRow = sheet.Cells(1, 1).End(xlDown).Row;
		//var lastCol = sheet.Cells(1, 1).End(xlToRight).Column;
		var lastRow = sheet.Cells(sheet.Rows.Count, 1).End(xlUp).Row;
		var lastCol = sheet.Cells(1, sheet.Columns.Count).End(xlToLeft).Column;
		LOG("last=(" + lastRow + "," + lastCol + ")");
		
		//for ( var r = 1; r <= lastRow; r++ ) {
		//	for ( var c = 1; c <= lastCol; c++ ) {
		//		LOG("cell(" + r + "," + c + ") = " + sheet.Cells(r, c).Value);
		//	}
		//}
		
		// �V�[�g���̎g�p�͈͂��擾
		var uRange = sheet.UsedRange;
		LOG("range=(" + uRange.Row + "," + uRange.Column + "), (" +
			(uRange.Row + uRange.Rows.Count - 1) + "," + (uRange.Column + uRange.Columns.Count - 1) + ")");
		
		var firstRow = uRange.Row;
		var firstCol = uRange.Column;
		var lastRow = uRange.Row + uRange.Rows.Count - 1;
		var lastCol = uRange.Column + uRange.Columns.Count - 1;
		
		for ( var r = firstRow; r <= lastRow; r++ ) {
			for ( var c = firstCol; c <= lastCol; c++ ) {
				LOG("cell(" + r + "," + c + ") = " + sheet.Cells(r, c).Text);
//				LOG("cell(" + r + "," + c + ") = " + sheet.Cells(r, c).Value);
			}
		}
	}
	
	
	//------------------------------------------
	// excel �㏈��
	//------------------------------------------
	// �N���[�Y
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	DebugUtil.Term();
	return 0;
}


