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
	var HEADER_ROW = 1;			// ヘッダの行番号
	var PATH_COL = 1;			// パスの列番号
	var m_tInfo = [];
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	var objSheet = objBook.WorkSheets(1);
	
	var lastRow = objSheet.Cells(objSheet.Rows.Count, 1).End(xlUp).Row;
	var lastCol = objSheet.Cells(HEADER_ROW, objSheet.Columns.Count).End(xlToLeft).Column;
	
	// ヘッダー解析
	for ( var c = 1; c <= lastCol; c++ ) {
		var text = objSheet.Cells(HEADER_ROW, c).Text;
		if ( text == "Path" ) {
			PATH_COL = c;
		} else {
			var tmp = text.split("/");
			m_tInfo.push( { "sheet": tmp[0], "row": parseInt(tmp[1]), "col": parseInt(tmp[2]), "valcol": c } );
		}
	}
	LOG("-----------------------");
	for ( var i in m_tInfo ) {
		LOG("m_tInfo[" + i + "]");
		for ( var j in m_tInfo[i] ) {
			LOG("  " + j + " : " + m_tInfo[i][j]);
		}
	}
	LOG("-----------------------");
	
	// 行解析
	for ( var r = HEADER_ROW + 1; r <= lastRow; r++ ) {
		var path = objSheet.Cells(r, PATH_COL).Text;
		var objTargetBook = objExcel.Workbooks.Open(path);
		
		for ( var i in m_tInfo ) {
			var objTargetSheet = objTargetBook.WorkSheets( m_tInfo[i].sheet );
			var val_after = objSheet.Cells(r, m_tInfo[i].valcol).Text;
			
			// 値の変更
			LOG(objTargetSheet.Cells(m_tInfo[i].row, m_tInfo[i].col).Text + " => " + val_after);
//			objTargetSheet.Cells(m_tInfo[i].row, m_tInfo[i].col).Value = val_after;
		}
		
		// 保存
//		objTargetBook.Save();
		
		// クローズ
		objTargetBook.Close();
	}
	
	objExcel.Quit();
	objExcel = null;
	
	return 0;
}


function LOG( str )
{
	WScript.Echo(str);
}
