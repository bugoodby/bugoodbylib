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
	if ( !checkExtension(argv(0)) ) {
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
		var btn = wshShell.Popup("拡張子 " + ext + " です。実行しますか？", 0, "invalid extension", 4/*MB_YESNO*/);
		if ( btn != 6/*IDYES*/ ) { ret = false; }
		break;
	}
	return ret;
}

function ExecScript( filespec )
{
	var rootDir = fso.GetParentFolderName(filespec);
	
	// resultフォルダ作成
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "\\result\\");
//	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "..\\result\\");
	cleanup_folder(resultDir);
	
	// テンプレートの存在確認
	var templateDir = rootDir + "\\template";
	if ( !fso.FolderExists(templateDir) ) {
		LOG("[ERROR] copy_and_rename: not found " + templateDir);
		return false;
	}
	
	// 設定表の読み込み
	var reader = new ExcelTableReader();
	if ( ! reader.Open(filespec) ) {
		return false;
	}
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	// 設定表の全レコードに対して処理実行
	var count = reader.GetRowCount();
	for ( var r = 1; r <= count; r++ )
	{
		var id = reader.GetText(r, "ID");
		var targetDir = resultDir + id;
		
		LOG("***" + id + "***");
		if ( id == "" ) {
			LOG("[ERROR] invalid id");
			continue;
		}
		
		// テンプレートのコピー
//		LOG("[copy] " + templateDir + " -> " + targetDir);
		fso.CopyFolder(templateDir, targetDir);
		WScript.Sleep(500);
		
		//===================================================
		// Excel編集
		var path = targetDir + "\\main.xls";
		var objTargetBook = objExcel.Workbooks.Open(path);
		var objTargetSheet = objTargetBook.WorkSheets("Sheet1");
		
		//---------------------------
		objTargetSheet.Range("B5").Value = id;
		objTargetSheet.Range("C5").Value = reader.GetText(r, "NAME");
		objTargetSheet.Range("F9").Value = reader.GetText(r, "DETAILS");
		
		var bin = reader.GetText(r, "BIN");
		var ary = reader.GetTextArray(r, "MULTI");
		if ( ary.length > 0 ) {
			for ( var i in ary ) {
				objTargetSheet.Range("G5").Offset(i, 0).Value = ary[i].replace("BINFILE", bin);
			}
		}
		else
		{
			if ( bin != "" ) {
			}
			else {
			}
		}
		
		var src = rootDir + "\\" + bin;
		if ( bin != "" ) {
			var dst = targetDir + "\\BINFILE";
			fso.CreateFolder(dst);
			if ( fso.FileExists(src) ) {
				fso.CopyFile(src, dst + "\\");
			} else {
				LOG("[ERROR] not found BIN: " + src);
			}
		}
		
		var pdfs = reader.GetTextArray(r, "PDF");
		if ( pdfs.length > 0 ) {
			var dst = targetDir + "\\PDFFILE";
			fso.CreateFolder(dst);
			for ( var i in pdfs ) {
				var src = rootDir + "\\" + pdfs[i];
				if ( fso.FileExists(src) ) {
					fso.CopyFile(src, dst + "\\");
				} else {
					LOG("[ERROR] not found PDF: " + src);
				}
			}
		}
		//---------------------------
		// 保存
		objTargetBook.Save();
		// クローズ
		objTargetBook.Close();
		
		//===================================================
		// Text編集
		var path = targetDir + "\\test.txt";
		var ws = fso.OpenTextFile(path, 8/*ForAppending*/, true, 0);
		var ary = reader.GetTextArray(r, "MULTI");
		for ( var i in ary ) {
			ws.WriteLine(ary[i]);
		}
		ws.Close();
		
		//===================================================
		// template2編集
		var params = {};
		params["HOGEHOGE1"] = "this is test";
		params["HOGEHOGE2"] = reader.GetText(r, "PARAM1");
		params["HOGEHOGE3"] = reader.GetText(r, "PARAM2");
		if ( params["HOGEHOGE2"] != "" && params["HOGEHOGE3"] != "" )
		{
			genFileFromTemplate(rootDir + "\\template2", targetDir + "\\BINFILE", params);
		}
	}
	
	objExcel.Quit();
	objExcel = null;
	
	reader.Close();
	
	return true;
}

function cleanup_folder( folder )
{
	var ret = true;
	try {
		if ( folder.slice(-1) == "\\" ) folder = folder.slice(0, -1);
		if ( fso.FolderExists(folder) ) {
			LOG("[del] " + folder);
			fso.DeleteFolder(folder, true);
		}
		LOG("[create] " + folder);
		fso.CreateFolder(folder);
	}
	catch ( e ) {
		LOG("[exception] cleanup_folder: " + folder + "\n" + e.description)
		ret = false;
	}
	return ret;
}

function genFileFromTemplate( srcDir, outDir, params )
{
	var GetLines = function( filespec, newline ) {
		var lines = null;
		if ( fso.FileExists(filespec) ) {
			var rs = fso.OpenTextFile(filespec, 1, false, 0);
			var text = rs.ReadAll();
			rs.Close();
			lines = text.split(newline);
		} else {
			LOG("[ERROR] file not found : " + filespec);
		}
		return lines;
	};
	
	var tmpl = srcDir + "\\template.txt";
	var outfile = outDir + "\\outfile.txt";
	var lines = GetLines(tmpl, "\r\n");
	
	if ( !fso.FolderExists(outDir) ) {
		fso.CreateFolder(outDir);
	}
	var ws = fso.OpenTextFile( outfile, 2/*ForWriting*/, true, 0 );
	
	for ( var i in lines )
	{
		for ( var key in params )
		{
			if ( lines[i].indexOf(key) != -1 ) {
				lines[i] = lines[i].replace(key, params[key]);
			}
		}
		ws.WriteLine(lines[i]);
	}
	
	ws.close();
	return true;
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
}
function LOG( str )
{
	WScript.Echo(str);
}
