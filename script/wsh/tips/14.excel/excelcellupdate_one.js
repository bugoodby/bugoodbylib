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
	var sheet_name = "URL_List";
	var target_row = 1;
	var target_col = 2;
	var val_after = "変更後の値";
	
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	
	// 対象シートを取得
	var objTargetSheet = objBook.WorkSheets(sheet_name);
	if ( !objTargetSheet ) {
		LOG("ERROR : シートがありません (" + sheet_name + ")");
		return 1;
	}
	
	// 値の変更
	LOG(objTargetSheet.Cells(target_row, target_col).Value + " => " + val_after);
	objTargetSheet.Cells(target_row, target_col).Value = val_after;
	
	// 保存
	objBook.Save();
	
	// クローズ
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	return 0;
}


function LOG( str )
{
	WScript.Echo(str);
}
