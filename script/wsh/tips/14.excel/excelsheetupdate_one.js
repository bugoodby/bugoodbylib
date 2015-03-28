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
	var org_path = WScript.ScriptFullName.replace(WScript.ScriptName, "test_orgdata.xls");
	var sheet_name = "URL_List";
	
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	// 元データファイルを読み取り専用で開く
	var oOrgBook = objExcel.Workbooks.Open(org_path, null, true);
	var oOrgSheet = oOrgBook.WorkSheets(sheet_name);
	if ( !oOrgSheet ) {
		LOG("ERROR : シートがありません (" + sheet_name + ")");
		return 1;
	}
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	
	// 対象シートを取得
	var objTargetSheet = objBook.WorkSheets(sheet_name);
	if ( !objTargetSheet ) {
		LOG("ERROR : シートがありません (" + sheet_name + ")");
		return 1;
	}
	
	oOrgSheet.Cells.Copy();
	objTargetSheet.Cells.PasteSpecial();
	
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
