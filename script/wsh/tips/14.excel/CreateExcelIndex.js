main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	if ( !checkExtension(argv(0)) ) {
		return 1;
	}
	
	// WScriptならCScriptで起動し直し
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function checkExtension( filespec )
{
	var ret = true;
	var fso = new ActiveXObject("Scripting.FileSystemObject");
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
	var Row_Header 		= 5;		//ヘッダの行番号
	var Column_Count	= 2;		//番号を表示する列
	var Column_Link		= 3;		//ハイパーリンクを表示する列
	
	//------------------------------------------
	// excel 前処理
	//------------------------------------------
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	
	//------------------------------------------
	// excel 本処理
	//------------------------------------------
	var names = [];
	var objSheets = objBook.WorkSheets;
	var e = new Enumerator(objSheets);
	for ( ; !e.atEnd(); e.moveNext() ) {
		var sheet = e.item();
		names.push(sheet.Name);
	}
	
	var objIndexSheet = objSheets.Add(objSheets(1));
	objIndexSheet.Name = "目次";
	objIndexSheet.Cells(Row_Header, Column_Link).Value = "＜＜目次＞＞"
	
	var row = Row_Header + 1;
	for ( var i in names ) {
		WScript.Echo(i + " : " + names[i]);
		objIndexSheet.Cells(row + parseInt(i), Column_Count).Value = parseInt(i) + 1;
		objIndexSheet.Cells(row + parseInt(i), Column_Link).Formula = '=HYPERLINK("#\'' + names[i] + '\'!A1", "' + names[i] + '")';
	}
	
	//------------------------------------------
	// excel 後処理
	//------------------------------------------
	// 列の幅を自動調整
	for ( var i = Column_Count; i <= Column_Link; i++ ) {
		objIndexSheet.Cells(1, i).EntireColumn.AutoFit();
	}
	
	// オブジェクトの破棄
	objExcel = null;
	
	WScript.Echo( "目次の作成が終了しました。" );
	return 0;
}


