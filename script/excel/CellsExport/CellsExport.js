//------------------------------------------------
// Excel定数
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
//------------------------------------------------

var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	
	var ext = fso.GetExtensionName(argv(0));
	if ( ext == "txt" ) {
		Import(argv(0));
	} else {
		Export(argv(0));
	}
}

functino Export( filespec )
{
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open( argv(0) );
	
	var out_file = objBook.Path + "\\output.txt";
	var ws = fso.OpenTextFile(out_file, 2/*ForWriting*/, true, 0);
	
	//------------------------------------------
	// 共通
	//------------------------------------------
	ws.WriteLine("[Common-Start]");
	ws.WriteLine("version=" + objBook.WorkSheets("Sheet1").Range("A1"));
	ws.WriteLine("path=" + objBook.WorkSheets("Sheet1").Range("G3"));
	ws.WriteLine("[Common-End]");
	
	//------------------------------------------
	// Sheet1
	//------------------------------------------
	{
		var objSheet = objBook.WorkSheets("Sheet1");
		
		// テーブルの行数、列数を取得
		var startRow = 6;
		var lastRow = objSheet.Cells(objSheet.Rows.Count, 1).End(xlUp).Row;
		
		ws.WriteLine("[Sheet1-Start]");
		for ( var r = startRow; r <= lastRow; r++ ) {
			ws.WriteLine("あああ=" + objSheet.Cells(r, 1));
			ws.WriteLine("いいい=" + objSheet.Cells(r, 2));
			ws.WriteLine("ううう=" + objSheet.Cells(r, 3));
			ws.WriteLine("えええ=" + objSheet.Cells(r, 4));
			ws.WriteLine("END");
		}
		ws.WriteLine("[Sheet1-End]");
	}
	
	// クローズ
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	ws.Close();
	
	return 0;
}

function Import( filespec )
{
}

