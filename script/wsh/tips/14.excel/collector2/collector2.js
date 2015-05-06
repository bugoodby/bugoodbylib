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
		
		m_fileList.length = 0;
		m_row = 1;
		
		return true;
	};
	
	this.term = function()
	{
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
		var r = 0;
		LOG("[target] " + f);
		try {
			// ヘッダ作成
			m_oOutSheet.Cells(m_row, 1).Formula = '=HYPERLINK("' + f + '", "' + f + '")';
			m_oOutSheet.Rows(m_row + ":" + m_row).Interior.Color = RGB(0xff,0xcc,0xff);
			m_row++;
			
			// 対象Excelを開く
			var oBook = m_oExcel.Workbooks.Open(f);
			var oSheet = oBook.WorkSheets("target");
			
			// ENDまでの行をカウント
			for ( r = 4; r < 1000; r++ ) {
				if ( oSheet.Cells(r, 1).Text == "END" ) {
					r--;
					break;
				}
			}
			
			// コピペ
			oSheet.Rows("4:" + r).Copy();
			m_oOutSheet.Rows(m_row + ":" + m_row).PasteSpecial();
			oBook.Close();
			m_row += (r - 3);
		}
		catch (e) {
			LOG("[ERROR] " + e.description);
			m_oOutSheet.Cells(m_row, 1).Value = e.description;
			m_row++;
			return false;
		}
		return true;
	};
}

function LOG( str )
{
	WScript.Echo(str);
}

