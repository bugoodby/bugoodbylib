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
	Sample_ExcelTableReader();
}

function Sample_ReadExcel()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test1.xls");
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	var objBook = objExcel.Workbooks.Open(file);
	var objSheet = objBook.WorkSheets(1);
	
	LOG( "Cells(7, 4): " + objSheet.Cells(7, 4).Text );
	LOG( "Range(D7)  : " + objSheet.Range("D7").Text );
	
	
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
}

function Sample_ExcelTableReader()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test1.xls");
	
	var reader = new ExcelTableReader();
	if ( ! reader.Open(file, "URL_List", 3, 2) ) {
		return false;
	}
	
	var count = reader.GetRowCount();
	for ( var r = 1; r <= count; r++ )
	{
		LOG("--------");
		LOG( reader.GetText(r, "Site") );
		LOG( reader.GetText(r, "URL") );
		LOG( reader.GetText(r, "���݂��Ȃ����ږ�") );
		
		var color = reader.GetColor(r, "Site");
		LOG("color = " + color);
		LOG(( color == RGB(255, 255, 255) ) ? "while" : "others");
	}
	reader.Close();
}


// Excel�̃e�[�u���������N���X
function ExcelTableReader()
{
	var HEADER_ROW = 1;			// �w�b�_�̍s�ԍ�
	var START_COL = 1;		// ��ƂȂ��ԍ�
	var m_oExcel = null;
	var m_oSheet = null;
	var m_lastRow = 0;
	var m_lastCol = 0;
	var m_hdr = {};
	
	this.Open = function( filespec, opt_sheet_name, opt_header_row, opt_start_col )
	{
		sheetname = opt_sheet_name || "Sheet1";
		HEADER_ROW = opt_header_row || 1;
		START_COL = opt_start_col || 1;
		
		// Excel�I�u�W�F�N�g�̍쐬
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// �E�B���h�E�\���ݒ�
		m_oExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
		
		// Excel�t�@�C����ǂݎ���p�ŊJ��
		var oBook = m_oExcel.Workbooks.Open(filespec, null, true);
		m_oSheet = oBook.WorkSheets(sheetname);
		
		LOG("+-[ExcelTableReader]----------------");
		LOG("| " + filespec);
		// �e�[�u���̍s���A�񐔂��擾
		m_lastRow = m_oSheet.Cells(m_oSheet.Rows.Count, START_COL).End(xlUp).Row;
		m_lastCol = m_oSheet.Cells(HEADER_ROW, m_oSheet.Columns.Count).End(xlToLeft).Column;
		LOG("| TABLE RANGE: (" + (HEADER_ROW+1) + "," + START_COL + ") , (" + m_lastRow + "," + m_lastCol + ")");
		
		// �w�b�_�[���
		LOG("| HEADER ITEMS:");
		for ( var c = START_COL; c <= m_lastCol; c++ )
		{
			var txt = m_oSheet.Cells(HEADER_ROW, c).Text;
			m_hdr[txt] = c;
			LOG("|   " + txt);
		}
		LOG("------------------------------------");
		return true;
	}
	
	this.Close = function()
	{
		m_oExcel.Quit();
		m_oExcel = null;
	}
	
	this.GetRowCount = function()
	{
		return m_lastRow - HEADER_ROW;
	}
	
	this.GetText = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetText: invalid itemName " + itemName);
			return "";
		}
		return m_oSheet.Cells(HEADER_ROW + rowNumber, c).Text;
	}
	
	this.GetTextArray = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetText: invalid itemName " + itemName);
			return [];
		}
		var a = m_oSheet.Cells(HEADER_ROW + rowNumber, c).Text.split("\n");
		var b = [];
		for ( var i in a ) {
			if ( a[i] != "" ) b.push(a[i]);
		}
		return b;
	}
	
	this.GetColor = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetText: invalid itemName " + itemName);
			return "";
		}
		return m_oSheet.Cells(HEADER_ROW + rowNumber, c).Interior.Color;
	}
}

function RGB(red, green, blue)
{
	return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
}

function LOG( str )
{
	WScript.Echo(str);
}
