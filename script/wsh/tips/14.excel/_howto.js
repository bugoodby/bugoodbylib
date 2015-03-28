//------------------------------------------------
// Excel定数
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
 
var xlWorkbookNormal		= -4143;
var xlNone 					= -1412;
 
//-- 貼り付け対象 --
var xlPasteAll				= -4104;		//すべて
var xlPasteFormulas			= -4123;		//数式
var xlPasteValues			= -4163;		//値
var xlPasteFormats			= -4122;		//書式
var xlPasteComments			= -4144;		//コメント
var xlDataValidation		= 6;			//入力規則
var xlPasteAllExceptBorders = 7;			//罫線を除くすべて
var xlPasteColumnWidths 	= 8;			//列幅
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	// WScriptならCScriptで起動し直し
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
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
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
		LOG( reader.GetText(r, "存在しない項目名") );
		
		var color = reader.GetColor(r, "Site");
		LOG("color = " + color);
		LOG(( color == RGB(255, 255, 255) ) ? "while" : "others");
	}
	reader.Close();
}


// Excelのテーブルを扱うクラス
function ExcelTableReader()
{
	var HEADER_ROW = 1;			// ヘッダの行番号
	var START_COL = 1;		// 基準となる列番号
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
		
		// Excelオブジェクトの作成
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// ウィンドウ表示設定
		m_oExcel.DisplayAlerts = false;		// アラート設定
		
		// Excelファイルを読み取り専用で開く
		var oBook = m_oExcel.Workbooks.Open(filespec, null, true);
		m_oSheet = oBook.WorkSheets(sheetname);
		
		LOG("+-[ExcelTableReader]----------------");
		LOG("| " + filespec);
		// テーブルの行数、列数を取得
		m_lastRow = m_oSheet.Cells(m_oSheet.Rows.Count, START_COL).End(xlUp).Row;
		m_lastCol = m_oSheet.Cells(HEADER_ROW, m_oSheet.Columns.Count).End(xlToLeft).Column;
		LOG("| TABLE RANGE: (" + (HEADER_ROW+1) + "," + START_COL + ") , (" + m_lastRow + "," + m_lastCol + ")");
		
		// ヘッダー解析
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
