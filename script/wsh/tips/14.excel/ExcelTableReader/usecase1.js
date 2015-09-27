var fso = new ActiveXObject("Scripting.FileSystemObject");
var xlPasteValues = -4163;


main( WScript.Arguments.Count(), WScript.Arguments );

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
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "database.csv");
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	var reader = new ExcelTableReader();
	if ( ! reader.Open(file, 1, 7, 1) ) {
		return false;
	}
	
	// 結果ファイルのdataシートを選択
	var outPath = WScript.ScriptFullName.replace(WScript.ScriptName, "out.xlsx");
	var objOutBook = objExcel.Workbooks.Open(outPath);
	var objOutSheet = objOutBook.WorkSheets("Sheet1");
	
	reader.CopyItems("大項目");
	objOutSheet.Cells(2,1).PasteSpecial(xlPasteValues);
	
	reader.CopyItems("ID");
	objOutSheet.Cells(2,2).PasteSpecial(xlPasteValues);
	
	reader.CopyItems("テスト");
	objOutSheet.Cells(2,3).PasteSpecial(xlPasteValues);
	
	reader.CopyItems("合計");
	objOutSheet.Cells(2,6).PasteSpecial(xlPasteValues);
	
	reader.Close();
	
	objOutBook.WorkSheets("Sheet2").PivotTables("ﾋﾟﾎﾞｯﾄﾃｰﾌﾞﾙ1").PivotCache().Refresh();
	
	objOutBook.Save();
	objOutBook.Close();
	objExcel.Quit();
}


// Excelのテーブルを扱うクラス
function ExcelTableReader()
{
	var m_sheetName = "";
	var m_headerRow = 1;
	var m_startCol = 1;		// 基準となる列番号
	var m_oExcel = null;
	var m_oSheet = null;
	var m_lastRow = 0;
	var m_lastCol = 0;
	var m_hdr = {};
	
	var xlUp		= -4162;
	var xlDown		= -4121;
	var xlToLeft	= -4159;
	var xlToRight	= -4161;
	
	// xlsファイルを開きテーブルを解析する
	this.Open = function( filespec, opt_sheet_name, opt_header_row, opt_start_col )
	{
		m_sheetName = opt_sheet_name || "Sheet1";
		m_headerRow = opt_header_row || 1;
		m_startCol = opt_start_col || 1;
		
		// Excelオブジェクトの作成
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// ウィンドウ表示設定
		m_oExcel.DisplayAlerts = false;		// アラート設定
		
		// Excelファイルを読み取り専用で開く
		var oBook = m_oExcel.Workbooks.Open(filespec, null, true);
		m_oSheet = oBook.WorkSheets(m_sheetName);
		
		// テーブルの行数、列数を取得
		m_lastRow = m_oSheet.Cells(m_oSheet.Rows.Count, m_startCol).End(xlUp).Row;
		m_lastCol = m_oSheet.Cells(m_headerRow, m_oSheet.Columns.Count).End(xlToLeft).Column;
		
//		for ( var r = m_headerRow+1; r <= 65536; r++ ) {
//			if ( m_oSheet.Cells(r, m_startCol).Value == "合計" ) {
//				m_lastRow = r - 1;
//				break;
//			}
//		}
		
		
		LOG("+-[ExcelTableReader]----------------");
		LOG("| FILE : " + filespec);
		LOG("| TABLE RANGE: start: (" + (m_headerRow+1) + "," + m_startCol + ") = " + m_oSheet.Cells((m_headerRow+1),m_startCol).Address);
		LOG("|              end  : (" + m_lastRow + "," + m_lastCol + ") = " + m_oSheet.Cells((m_lastRow),m_lastCol).Address);
		LOG("| ROWS   : " + (m_lastRow - m_headerRow));
		LOG("| COLUMNS: " + (m_lastCol - m_startCol + 1));
		// ヘッダー解析
		LOG("| HEADER ITEMS:");
		for ( var c = m_startCol; c <= m_lastCol; c++ )
		{
			var txt = m_oSheet.Cells(m_headerRow, c).Text;
			m_hdr[txt] = c;
			LOG("|   " + txt);
		}
		LOG("------------------------------------");
		
		return true;
	}
	
	// xlsファイルを閉じる
	this.Close = function()
	{
		m_oExcel.Quit();
		m_oExcel = null;
	}
	
	// テーブルの行数を返す
	this.GetRowCount = function()
	{
		return m_lastRow - m_headerRow;
	}
	
	// テーブルの
	//  - rowNumber行目
	//  - 項目名がitemName
	// であるセルの値を返す
	this.GetText = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetText: invalid itemName " + itemName);
			return "";
		}
		return m_oSheet.Cells(m_headerRow + rowNumber, c).Text;
	}
	
	// テーブルの
	//  - rowNumber行目
	//  - 項目名がitemName
	// であるセルの値を、１行テキストの配列として返す
	this.GetTextArray = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetTextArray: invalid itemName " + itemName);
			return [];
		}
		var a = m_oSheet.Cells(m_headerRow + rowNumber, c).Text.split("\n");
		var b = [];
		for ( var i in a ) {
			if ( a[i] != "" ) b.push(a[i]);
		}
		return b;
	}
	
	// テーブルの
	//  - rowNumber行目
	//  - 項目名がitemName
	// であるセルの背景色を返す
	this.GetColor = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetColor: invalid itemName " + itemName);
			return 0;
		}
		return m_oSheet.Cells(m_headerRow + rowNumber, c).Interior.Color;
	}
	
	// テーブルの
	//  - 項目名がitemName
	// である範囲をコピーする
	this.CopyItems = function( itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] CopyItems: invalid itemName " + itemName);
			return;
		}
		var startRange = m_oSheet.Cells((m_headerRow+1), c).Address;
		var endRange = m_oSheet.Cells(m_lastRow, c).Address;
		var copyRange = startRange + ":" + endRange;
		LOG(copyRange);
		m_oSheet.Range(copyRange).Copy();
	}
}

function LOG( str )
{
	WScript.Echo(str);
}
