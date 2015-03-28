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
	
	return ExecScript();
}

function ExecScript( filespec )
{
	var csvPath = WScript.ScriptFullName.replace(WScript.ScriptName, "test.csv");
	var outPath = WScript.ScriptFullName.replace(WScript.ScriptName, "dst.xlsx");
	
	if ( !fso.FileExists(csvPath) ) {
		LOG("[ERROR] file not found : " + csvPath);
		return 0;
	}
	if ( !fso.FileExists(outPath) ) {
		LOG("[ERROR] file not found : " + outPath);
		return 0;
	}
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	
	// 結果ファイルを開く
	var objOutBook = objExcel.Workbooks.Open(outPath);
	// 結果ファイルのシート名一覧を取得
	var counter = {};
	var e = new Enumerator(objOutBook.WorkSheets);
	for ( ; !e.atEnd(); e.moveNext() ) {
		var sheet = e.item();
		if ( sheet.Name != "グラフ" ) {
			counter[sheet.Name] = 1;
			sheet.Cells.Clear();
		}
	}
	
	// csvを読み取り専用で開く
	var objCsvBook = objExcel.Workbooks.Open(csvPath, null, true);
	var objCsvSheet = objCsvBook.WorkSheets(1);
	// シート内の使用範囲を取得
	var uRange = objCsvSheet.UsedRange;
	LOG("CSV: range=(" + uRange.Row + "," + uRange.Column + "), (" +
		(uRange.Row + uRange.Rows.Count - 1) + "," + (uRange.Column + uRange.Columns.Count - 1) + ")");
	
	var row_start = 1;
	var row_end = uRange.Row + uRange.Rows.Count - 1;
	
	for ( var r = row_start; r <= row_end; r++ )
	{
		var keyword = objCsvSheet.Cells(r, 3).Text;
		if ( keyword != "" ) {
			objCsvSheet.Cells(r, 1).EntireRow.Copy();
			if ( keyword == "タイトル行" ) {
				// ヘッダ行を結果ファイルの全シートへコピー
				for ( var s in counter ) {
					objOutBook.WorkSheets(s).Cells(counter[s], 1).EntireRow.PasteSpecial();
					counter[s]++;
				}
			} else {
				if ( !counter[keyword] ) {
					LOG("ERROR : シートがありません (" + keyword + ")");
				} else {
					// 結果ファイルのそれぞれのシートにコピー
					objOutBook.WorkSheets(keyword).Cells(counter[keyword], 1).EntireRow.PasteSpecial();
					counter[keyword]++;
				}
			}
		}
	}
	
	// CSVファイルを閉じる
	objCsvBook.Close();
	
	// 出力ファイルの保存
	objOutBook.Save();
	objOutBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	return 0;
}


function LOG( str )
{
	WScript.Echo(str);
}
