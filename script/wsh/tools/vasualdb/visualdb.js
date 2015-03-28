
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
var xlPasteAll				= -4104;	//すべて
var xlPasteFormulas			= -4123;	//数式
var xlPasteValues			= -4163;	//値
var xlPasteFormats			= -4122;	//書式
var xlPasteComments			= -4144;	//コメント
var xlDataValidation		= 6;		//入力規則
var xlPasteAllExceptBorders = 7;		//罫線を除くすべて
var xlPasteColumnWidths 	= 8;		//列幅

//-- 罫線の位置 --
var xlEdgeLeft				= 7;
var xlEdgeTop				= 8;
var xlEdgeBottom			= 9;
var xlEdgeRight				= 10;
var xlInsideVertical		= 11;
var xlInsideHorizontal		= 12;
//-- 罫線の種類 --
var xlContinuous			= 1;
var xlDash					= -4115;
var xlDashDot				= 4;
var xlDashDotDot			= 5;
var xlDot					= -4118;
var xlDouble				= -4119;
//-- 罫線の太さ --
var xlHairLine				= 1;
var xlThin					= 2;
var xlThick					= 4;
var xlMedium				= -4138;
//-----------------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");

main( WScript.Arguments.Count(), WScript.Arguments );

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
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argc, argv);
}

function ExecScript( argc, argv )
{
	var dbm = new DatabaseManager();
	
	// 設定ファイル読み込み、DB一覧を作成
	// 各ファイルをダウンロード
	var rs = fso.OpenTextFile(argv(0), 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split("\r\n");
	for ( var i in lines ) {
		if ( lines[i].length == 0 || lines[i].charAt(0) == ';' ) {
			continue;
		}
		var delimiter = lines[i].search("=");
		if ( delimiter != -1 ) {
			var name = lines[i].slice(0, delimiter).replace(/^\s+|\s+$/g, "");
			var title = lines[i].slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
			title = title.replace(/\\r\\n/g, String.fromCharCode(10));
			dbm.ReadDatabaseText(name, title);
		}
	}
	dbm.MakeExcel(fso.GetBaseName(argv(0)));
	
	return 0;
}

//------------------------------------------------
// DatabaseManager Class
//------------------------------------------------
function DatabaseManager()
{
	var plAry = new Array();
	var plCount = 0;
	var db = new Array();
	var rootDir = WScript.ScriptFullName.replace(WScript.ScriptName, "");
	var dbDir = rootDir + "database\\";
	var resultDir = rootDir + "result\\";
	
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	var init = function( type )
	{
		// databaseフォルダ作成
		if ( !fso.FolderExists(dbDir) ) {
			fso.CreateFolder(dbDir);
			LOG("created: " + dbDir);
		}
		
		// resultフォルダ作成
		if ( !fso.FolderExists(resultDir) ) {
			fso.CreateFolder(resultDir);
			LOG("created " + resultDir);
		}
	}
	
	var UpdateRecord = function( name, val )
	{
		if ( !db[name] ) {
			db[name] = new Array();
		}
		db[name][plCount] = val;
	}
	
	this.ReadDatabaseText = function( name, title )
	{
		var filespec = dbDir + name;
		
		//ファイルの存在チェック
		if ( !fso.FileExists(filespec) ) {
			LOG("[ERROR] file not found : " + filespec);
			return false;
		}
		plAry[plCount] = title;
		
		//メモリに読み込み
		var rs = fso.OpenTextFile(filespec, 1/*ForReading*/, false, 0);
		var text = rs.ReadAll();
		rs.Close();
		var lines = text.split("\r\n");
		
		if ( lines[0].match(/^;TYPE:2/) ) {
			LOG("Type2: " + filespec);
			ReadDB_type2(lines);
		} else {
			LOG("Type1: " + filespec);
			ReadDB_type1(lines);
		}
		
		plCount++;
		return true;
	}
	
	// TYPE:1
	// リストされた単語をkeyにして存在したらセルに○を記入
	var ReadDB_type1 = function( lines )
	{
		for ( var i in lines ) {
			if ( lines[i].length == 0 || lines[i].charAt(0) == ';' ) {
				continue;
			}
			UpdateRecord(lines[i].replace(/^\s+|\s+$/g, ""), "○");
		}
	}
	
	// TYPE:2
	// *で始まる行をkeyにしてその後に続く文字列をセルに記入
	var ReadDB_type2 = function( lines )
	{
		var key = "";
		var val = "";
		
		for ( var i in lines ) {
			if ( lines[i].length == 0 || lines[i].charAt(0) == ';' ) {
				continue;
			}
			if ( lines[i].match(/^\*(.+)/) ) {
				if ( key != "" ) {
					UpdateRecord(key, val);
				}
				key = RegExp.$1.replace(/^\s+|\s+$/g, "");
				val = "";
			} else {
				if ( val != "" ) val += String.fromCharCode(10);
				val += lines[i];
			}
		}
		if ( key != "" ) {
			UpdateRecord(key, val);
		}
	}
	
	this.MakeExcel = function( name )
	{
		var Row_Header 		= 1;		//ヘッダの行番号
		var Column_Name		= 1;		//db名称を表示する列
		var Column_Ver		= 2;		//ver表記の開始列
		
		//行番号、列番号からRangeオブジェクトを取得する関数
		function getRange( objSheet, row_s, col_s, row_e, col_e )
		{
			return objSheet.Range(objSheet.Cells(row_s, col_s).address,
								objSheet.Cells(row_e, col_e).address);
		}
		//セルに罫線を引く関数
		function rulingRange( range )
		{
			var borders = [ xlEdgeLeft, xlEdgeRight, xlEdgeTop, xlEdgeBottom,
							xlInsideVertical, xlInsideHorizontal ];
			for ( var i in borders ) {
				var border = range.Borders(borders[i]);
				border.Weight = xlThin;
				border.LineStyle = xlContinuous;
			}
		}
		
		//------------------------------------------
		// excel 前処理
		//------------------------------------------
		// Excelオブジェクトの作成
		var objExcel = new ActiveXObject("Excel.Application");
		objExcel.Visible = true;			// ウィンドウ表示
		objExcel.DisplayAlerts = false;		// アラート停止
		
		// 出力ファイルを新規作成
		var objOutBook = objExcel.Workbooks.Add();
		var objOutSheet = objOutBook.Worksheets(1);
		objOutSheet.Select();

		//------------------------------------------
		// excel 本処理
		//------------------------------------------
		// ヘッダ行
		objOutSheet.Cells(Row_Header, Column_Name).Value = "Name";
		for ( var j = 0; j < plCount; j++ ) {
			objOutSheet.Cells(Row_Header, Column_Ver + j).Value = plAry[j];
		}
		rulingRange(getRange(objOutSheet, Row_Header, Column_Name, Row_Header, Column_Ver + plCount - 1));
		
		// 各pkgの行
		var i = Row_Header + 1;
		for ( var key in db ) {
			objOutSheet.Cells(i, Column_Name).Value = key;
			for ( var j = 0; j < plCount; j++ ) {
				if ( !db[key][j] ) {
					objOutSheet.Cells(i, Column_Ver + j).Interior.Color = RGB(217,217,217);
				} else {
					objOutSheet.Cells(i, Column_Ver + j).Value = db[key][j];
				}
			}
			rulingRange(getRange(objOutSheet, i, Column_Name, i, Column_Ver + plCount - 1));
			i++;
		}
		
		//------------------------------------------
		// excel 後処理
		//------------------------------------------
		var firstCol = Column_Name;
		var lastCol = objOutSheet.Cells(Row_Header, firstCol).End(xlToRight).Column;
		var rs = objOutSheet.Cells(Row_Header, firstCol).address;
		var re = objOutSheet.Cells(Row_Header, lastCol).address;
		
		// ヘッダの色付け
		objOutSheet.Range(rs, re).Interior.Color = RGB(253,233,217);
		// 列の幅を自動調整
		for ( var i = firstCol; i <= lastCol; i++ ) {
			objOutSheet.Cells(1, i).EntireColumn.AutoFit();
		}
		// オートフィルタの設定
		var range = objOutSheet.Cells(Row_Header, 1).EntireRow;
		range.AutoFilter();
		// ウィンドウ枠の固定
		objOutSheet.Cells(Row_Header + 1, Column_Name + 1).Select();
		objExcel.ActiveWindow.FreezePanes = true;
		
		// 出力ファイルの保存
		var outXlsPath = resultDir + name + ".xlsx";
		LOG("save: " + outXlsPath);
		objOutBook.SaveAs(outXlsPath);
//		objOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
		
		// クローズ
		objOutBook.Close();
		objExcel.Quit();
		
		// オブジェクトの破棄
		objExcel = null;
	};
	
	init();
}

function LOG( str )
{
	WScript.Echo(str);
}
