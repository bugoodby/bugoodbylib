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
	if ( argc != 3 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	
	LOG(argv(0));
	LOG(argv(1));
	LOG(argv(2));
	
	if ( argv(0) == "/import" ) {
		Import(argv(1), argv(2));
	}
	else if ( argv(0) == "/export" ) {
		Export(argv(1), argv(2));
	}
	else {
		LOG("Usage: CellsExportImport.js <mode> <data_file> <excel_file>\n");
	}
}

////////////////////////////////////////////////////////////////////////
function Export( filespec )
{
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open( filespec );
	
	var out_file = objBook.Path + "\\CellsExport.txt";
	var ws = fso.OpenTextFile(out_file, 2/*ForWriting*/, true, 0);
	
	//------------------------------------------
	// 共通
	//------------------------------------------
	ws.WriteLine("[Common-Start]");
	ws.WriteLine("version=" + objBook.WorkSheets("Sheet1").Range("B1").Text);
	ws.WriteLine("path=" + objBook.WorkSheets("Sheet1").Range("G3").Text);
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
			ws.WriteLine("あああ=" + encodeLF(objSheet.Cells(r, 1).Text));
			ws.WriteLine("いいい=" + encodeLF(objSheet.Cells(r, 2).Text));
			ws.WriteLine("ううう=" + encodeLF(objSheet.Cells(r, 3).Text));
			ws.WriteLine("えええ=" + encodeLF(objSheet.Cells(r, 4).Text));
			ws.WriteLine("END");
		}
		ws.WriteLine("[Sheet1-End]");
	}
	
	// クローズ
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	ws.Close();
}

function encodeLF( val )
{
	var str = "" + val;
	return str.replace(/\n/g, "###:::LF:::###");
}

////////////////////////////////////////////////////////////////////////
function Import( db_path, excel_path )
{
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// Excelファイルを開く
	var objBook = objExcel.Workbooks.Open( excel_path );
	
	var rs = fso.OpenTextFile(db_path, 1/*ForReading*/, false, 0);
	
	do {
		var line = rs.ReadLine();
		if ( line == "[Common-Start]" ) {
			ImportSub_Common(objBook, rs);
		}
		if ( line == "[Sheet1-Start]" ) {
			ImportSub_Sheet1(objBook, rs);
		}
	} while ( !rs.AtEndOfStream );
	
	// 保存
	objBook.Save();
	
	// クローズ
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	rs.Close();
}

function ImportSub_Common( objBook, rs )
{
	do {
		var line = rs.ReadLine();
		
		if ( line == "[Common-End]" ) {
			break;
		}
		
		var delimiter = line.search("=");
		if ( delimiter == -1 ) {
			LOG("無効な行です: " + line);
			continue;
		}
		
		var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
		var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
		
		switch ( key ) {
		case "version":
			objBook.WorkSheets("Sheet1").Range("B1").Value = val;
			break;
		case "path":
			objBook.WorkSheets("Sheet1").Range("G3").Value = val;
			break;
		default:
			break;
		}
		
	} while ( !rs.AtEndOfStream );
}

function ImportSub_Sheet1( objBook, rs )
{
	var r = 6;
	
	do {
		var line = rs.ReadLine();
		
		if ( line == "[Sheet1-End]" ) {
			break;
		}
		if ( line == "END" ) {
			r += 1;
			continue;
		}
		
		var delimiter = line.search("=");
		if ( delimiter == -1 ) {
			LOG("無効な行です: " + line);
			continue;
		}
		
		var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
		var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
		
		switch ( key ) {
		case "あああ":
			objBook.WorkSheets("Sheet1").Cells(r, 1).Value = decodeLF(val);
			break;
		case "いいい":
			objBook.WorkSheets("Sheet1").Cells(r, 2).Value = decodeLF(val);
			break;
		case "ううう":
			objBook.WorkSheets("Sheet1").Cells(r, 3).Value = decodeLF(val);
			break;
		case "えええ":
			objBook.WorkSheets("Sheet1").Cells(r, 4).Value = decodeLF(val);
			break;
		default:
			break;
		}
		
	} while ( !rs.AtEndOfStream );
}

function decodeLF( val )
{
	var str = "" + val;
	return str.replace(/###:::LF:::###/g, "\n");
}

////////////////////////////////////////////////////////////////////////
function LOG( str )
{
	WScript.Echo(str);
}
