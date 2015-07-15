var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
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

function ExecScript( filespec )
{
	// 出力フォルダ作成
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "source\\");
	if ( fso.FolderExists(resultDir) ) {
		LOG("[del] " + resultDir + "\\*");
		fso.DeleteFile(resultDir + "\\*", true);
	} else {
		LOG("[create] " + resultDir);
		fso.CreateFolder(resultDir);
	}
	
	//------------------------------------------
	// excel 前処理
	//------------------------------------------
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	
	//------------------------------------------
	// excel 本処理
	//------------------------------------------
	var objProject = objBook.VBProject;
	var compCount = objProject.VBComponents.Count;
	
	for ( var i = 1; i <= compCount; ++i ) {
		type = objProject.VBComponents(i).Type;
		switch ( type ) {
		case 1:  ext = ".bas"; break;
		case 2:  ext = ".frm"; break;
		default: ext = ".cls"; break;
		}
		
		LOG("[" + i + "] " + objProject.VBComponents(i).Name + ext);
		out = resultDir + objProject.VBComponents(i).Name + ext;
		objProject.VBComponents(i).Export( out );
	}
	
	//------------------------------------------
	// excel 後処理
	//------------------------------------------
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

