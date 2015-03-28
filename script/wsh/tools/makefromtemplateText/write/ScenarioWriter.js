//------------------------------------------------
// Excel定数
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");

WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
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
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
	cleanup_folder(resultDir);
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open(filespec);
	var objSheet = objBook.WorkSheets(1);
	
	// 1列目の最後の行取得
	var baseLastRow = objSheet.Cells(objSheet.Rows.Count, 1).End(xlUp).Row;
	
	var col = 1;
	while ( 1 )
	{
		// n列目の最後の行取得
		var curLastRow = objSheet.Cells(objSheet.Rows.Count, col).End(xlUp).Row;
		if ( curLastRow == 1 ) {
			break;
		}
		// 出力ファイル名決定
		var dataFile = objSheet.Cells(1, col).Text.replace(/^\s+|\s+$/g, "");
		if ( dataFile == "" ) {
			dataFile = "scenario" + col + ".txt";
		} else {
			dataFile +=  ".txt";
		}
		LOG("[" + col + "] " + dataFile);
		
		var ws = fso.OpenTextFile(resultDir + dataFile, 2/*ForWriting*/, true, 0);
		for ( var i = 2; i <= baseLastRow; i++ ) {
			if ( objSheet.Cells(i, col).Text != "" ) {
				ws.Write(objSheet.Cells(i, col).Text);
			} else {
				ws.Write(objSheet.Cells(i, 1).Text);
			}
			ws.Write("\r\n");
		}
		ws.Close();
		col++;
	}
	
	
	// クローズ
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
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


function LOG( str )
{
	WScript.Echo(str);
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
