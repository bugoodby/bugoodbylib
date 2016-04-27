//------------------------------------------------
// Excel定数
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
 
var xlWorkbookNormal		= -4143;
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	
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

function ExecScript( folder )
{
	var collector = new ExcelDataCollector();
	collector.init();
	collector.enumerate(folder);
	collector.exec();
	collector.term();
	
	return 0;
}

function ExcelDataCollector()
{
	var m_oExcel = null;
	var m_oOutBook = null;
	var m_oOutSheet = null;
	var m_fileList = [];
	var m_row = 0;
	
	var HEADER_ROW = 1;			// ヘッダの行番号
	var PATH_COL = 1;			// パスの列番号
	var VALUE_START_COL = 2;	// 取得値セルの開始列番号
	
	var m_tInfo = [
		{ "sheet": "target", "range": "A4" },
		{ "sheet": "target", "range": "E4" },
	];
	
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	this.init = function()
	{
		// Excelオブジェクトの作成
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// ウィンドウ表示設定
		m_oExcel.DisplayAlerts = false;		// アラート設定
		
		// 出力ファイルを新規作成
		m_oOutBook = m_oExcel.Workbooks.Add();
		m_oOutSheet = m_oOutBook.Worksheets(1);
		m_oOutSheet.Select();
		
		// ヘッダの作成
		m_oOutSheet.Cells(HEADER_ROW, PATH_COL).Value = "Path";
		m_oOutSheet.Cells(HEADER_ROW, PATH_COL).Interior.Color = RGB(192,192,192);
		for ( var i in m_tInfo ) {
			m_oOutSheet.Cells(HEADER_ROW, VALUE_START_COL + parseInt(i)).Value = m_tInfo[i].sheet + "/" + m_tInfo[i].range;
			m_oOutSheet.Cells(HEADER_ROW, VALUE_START_COL + parseInt(i)).Interior.Color = RGB(192,192,192);
		}
		
		m_fileList.length = 0;
		m_row = HEADER_ROW + 1;
		
		return true;
	};
	
	this.term = function()
	{
		// 列の幅を自動調整
		var lastCol = m_oOutSheet.Cells(HEADER_ROW, m_oOutSheet.Columns.Count).End(xlToLeft).Column;
		for ( var i = 1; i <= lastCol; i++ ) {
			m_oOutSheet.Cells(1, i).EntireColumn.AutoFit();
		}
		
		// オートフィルタの設定
		m_oOutSheet.UsedRange.AutoFilter();
		
		// 出力ファイルの保存
		var outXlsPath = WScript.ScriptFullName.replace(WScript.ScriptName, "result.xls");
	    m_oOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
		
		m_oOutBook.Close();
		m_oExcel.Quit();
		m_oExcel = null;
	};
	
	this.enumerate = function( folder )
	{
		var filter = "\.xls$";
		
		var enumerate_sub = function( folder ) {
			var d = fso.GetFolder(folder);
			var subdirs = new Enumerator(d.SubFolders);
			var files = new Enumerator(d.files);
			
			for ( ; !files.atEnd(); files.moveNext() ) {
				if ( files.item().Path.match(filter) ) {
					m_fileList.push(files.item().Path);
				}
			}
			for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
				enumerate_sub(subdirs.item().Path);
			}
		};
		
		LOG("Enumerate start: " + folder);
		m_fileList.length = 0;
		enumerate_sub(folder);
		LOG("Enumerate end: " + m_fileList.length);
	};
	
	this.exec = function()
	{
		for ( var i in m_fileList ) {
			collectData(m_fileList[i]);
		}
	};
	
	var collectData = function( f )
	{
		LOG("[target] " + f);
		try {
			var oBook = m_oExcel.Workbooks.Open(f);
			
			for ( var i in m_tInfo ) {
				var oSheet = oBook.WorkSheets( m_tInfo[i].sheet );
				var text = oSheet.Range( m_tInfo[i].range ).Text;
				m_oOutSheet.Cells( m_row, VALUE_START_COL + parseInt(i) ).Value = text;
			}
			
			m_oOutSheet.Cells( m_row, PATH_COL ).Value = f;
			m_row++;
			oBook.Close();
		}
		catch (e) {
			LOG("[ERROR] " + e.description);
			return false;
		}
		return true;
	};
}

function LOG( str )
{
	WScript.Echo(str);
}

