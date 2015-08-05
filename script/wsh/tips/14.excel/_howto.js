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
var xlPasteAll				= -4104;		//すべて
var xlPasteFormulas			= -4123;		//数式
var xlPasteValues			= -4163;		//値
var xlPasteFormats			= -4122;		//書式
var xlPasteComments			= -4144;		//コメント
var xlDataValidation		= 6;			//入力規則
var xlPasteAllExceptBorders = 7;			//罫線を除くすべて
var xlPasteColumnWidths 	= 8;			//列幅
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
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
	
	return ExecScript();
}

function ExecScript()
{
	Sample_ReadExcel();
	Sample_CreateExcel();
}

//----------------------------
// 基本テスト
//----------------------------
function Sample_ReadExcel()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test1.xls");
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	var objBook = objExcel.Workbooks.Open(file);
	var objSheet = objBook.WorkSheets(1);
	
	LOG( "Text" );
	LOG( "  - Cells(7,4): " + objSheet.Cells(7,4).Text );
	LOG( "  - Range(D7)  : " + objSheet.Range("D7").Text );
	
	LOG( "Range <-> Cells" );
	LOG( "  - Range(D7) => Cells(" + objSheet.Range("D7").Row + "," + objSheet.Range("D7").Column + ")" );
	LOG( "  - Cells(7,4) => Range(" + objSheet.Cells(7,4).Address + ")" );
	
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
}

function Sample_CreateExcel()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "test_created.xlsx");
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = false;		// アラート設定
	
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheet = objOutBook.WorkSheets(1);
	
	
	objOutSheet.Range("A1").Value = "ほげほげ";
	objOutSheet.Cells(2, 2).Formula = "=1+1";
	
	
	// 出力ファイルの保存
	LOG("save: " + file);
	objOutBook.SaveAs(file);
	
	objOutBook.Close();
	
	objExcel.Quit();
	objExcel = null;
}

function LOG( str )
{
	WScript.Echo(str);
}
