//------------------------------------------------
// ユーザー設定値
//------------------------------------------------
var HEADER_ROW = 2;			// ヘッダの行番号
var LEFTLIST_COL = 2;		// 文字列リスト(左)を書き出す列番号
var RIGHTLIST_COL = 3;		// 文字列リスト(右)を書き出す列番号

//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 2 ) {
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
		//cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0), argv(1));
}

function ExecScript( filespecL, filespecR )
{
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	// Excel定数
	var xlWorkbookNormal		= -4143;
	
	//------------------------------------------
	// 入力作業
	//------------------------------------------
	// 文字列リストを作成
	var aryL = ReadStringArray(filespecL);
	var aryR = ReadStringArray(filespecR);
	
	var countL = aryL.length;
	var countR = aryR.length;
	
	// 文字列リストをソート
	aryL.sort();
	aryR.sort();
	
	//------------------------------------------
	// 出力作業
	//------------------------------------------
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	// 出力ファイルを新規作成
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheet = objOutBook.Worksheets(1);
	objOutSheet.Select();
	
	// ヘッダの作成
	objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).Value = fso.GetFileName(filespecL) + " : " + countL;
	objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).Interior.Color = RGB(192,192,192);
	objOutSheet.Cells(HEADER_ROW, RIGHTLIST_COL).Value = fso.GetFileName(filespecR) + " : " + countR;
	objOutSheet.Cells(HEADER_ROW, RIGHTLIST_COL).Interior.Color = RGB(192,192,192);
	
	// リスト比較結果の作成
	var i = HEADER_ROW + 1;
	var l = 0, r = 0;
	
	while ( (l < countL) && (r < countR) ) {
		if ( aryL[l] == aryR[r] ) {
			WScript.Echo(i + ": " + aryL[l] + " | " + aryR[r]);
			objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
			objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
			l++;
			r++;
		}
		else if ( aryL[l] < aryR[r] ) {
			WScript.Echo(i + ": " + aryL[l] + " | ");
			objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
			objOutSheet.Cells(i, LEFTLIST_COL).Interior.Color = RGB(255,255,0);
			l++;
		}
		else {
			WScript.Echo(i + ":  | " + aryR[r]);
			objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
			objOutSheet.Cells(i, RIGHTLIST_COL).Interior.Color = RGB(255,255,0);
			r++;
		}
		i++;
	}
	
	while ( l < countL ) {
		WScript.Echo(i + ": " + aryL[l] + " | ");
		objOutSheet.Cells(i, LEFTLIST_COL).Value = aryL[l];
		objOutSheet.Cells(i, LEFTLIST_COL).Interior.Color = RGB(255,255,0);
		l++;
		i++;
	}
	while ( r < countR ) {
		WScript.Echo(i + ":  | " + aryR[r]);
		objOutSheet.Cells(i, RIGHTLIST_COL).Value = aryR[r];
		objOutSheet.Cells(i, RIGHTLIST_COL).Interior.Color = RGB(255,255,0);
		r++;
		i++;
	}
	
	// 列の幅を自動調整
	objOutSheet.Cells(1, LEFTLIST_COL).EntireColumn.AutoFit();
	objOutSheet.Cells(1, RIGHTLIST_COL).EntireColumn.AutoFit();
	
	// オートフィルタの設定
	rs = objOutSheet.Cells(HEADER_ROW, LEFTLIST_COL).address;
	re = objOutSheet.Cells(i, RIGHTLIST_COL).address;
	objOutSheet.Range(rs, re).AutoFilter();
	
	// 出力ファイルの保存
	var outXlsPath = WScript.ScriptFullName.replace(WScript.ScriptName, "diff_result.xls");
    objOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
	
	// クローズ
	//objOutBook.Close();
	//objExcel.Quit();
	
	// オブジェクトの破棄
	objExcel = null;
	
	return 0;
}

function ReadStringArray( filespec )
{
	var lines = [];
	
	// ファイルの存在チェック
	if ( !fso.FileExists(filespec) ) {
		WScript.Echo("[ERROR] " + filespec + " が存在しません");
		return lines;
	}
	
	// テキストを読み込んで行ごとに配列化
	var rs = fso.OpenTextFile(filespec, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	lines = text.split("\r\n");
	
	// 文字列の前後の空白を除去
	for ( var i in lines ) {
		lines[i] = lines[i].replace(/^\s+|\s+$/g, "");
	}
	return lines;
}

