//-----------------------------------------------------------
// DebugUtil v4
//-----------------------------------------------------------
var DebugUtil={c:true,f:false,ws:null,
	Init: function(target){this.c=true; this.f=false;
		if(target=="both"){this.f=true;} else if(target=="file"){this.c=false;this.f=true;}
		if(this.f){var fso=new ActiveXObject("Scripting.FileSystemObject");
		this.ws=fso.OpenTextFile(WScript.ScriptFullName.replace(WScript.ScriptName, "debuglog.txt"),8,true,0);
		this.ws.WriteLine("\n\n\n[[[LOG START: "+new Date()+" ]]]\n"); fso=null;}},
	Term: function(){if(this.f){this.ws.Close(); this.ws=null;}}
};
function LOG(str){
	if(DebugUtil.f){DebugUtil.ws.WriteLine(str);} if(DebugUtil.c){WScript.StdOut.WriteLine(str);}
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
//-----------------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
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
	DebugUtil.Init("both");
	
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "");
	var name = "ExcelDiffResult.xlsx";
	
	
	var ini = ReadINI(filespec);
	LOG_ARRAY(ini);
	
	//------------------------------------------
	// excel 前処理
	//------------------------------------------
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// ウィンドウ表示設定
	objExcel.DisplayAlerts = true;		// アラート設定
	
	// 出力ファイルを新規作成
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheets = objOutBook.WorkSheets;
	//始めから作成されているシート数を取得しておく
	var count = objOutSheets.Count
	
	
	//-------------------------------------
	// 比較元シート２をコピー
	//-------------------------------------
	var objInBook2 = objExcel.Workbooks.Open(ini["src2.path"], null, true);
	objInBook2.Worksheets(ini["src2.sheet"]).Copy(objOutSheets(1));	//最初に追加
	var objDiffSheet2 = objOutSheets(1);
	objDiffSheet2.Name = "比較元シート２";
	objInBook2.Close();
	
	//-------------------------------------
	// 比較元シート１をコピー
	//-------------------------------------
	var objInBook1 = objExcel.Workbooks.Open(ini["src1.path"], null, true);
	objInBook1.Worksheets(ini["src1.sheet"]).Copy(objOutSheets(1));	//最初に追加
	var objDiffSheet1 = objOutSheets(1);
	objDiffSheet1.Name = "比較元シート１";
	objInBook1.Close();
	
	//------------------------------------------
	// 比較結果シートを作成
	//------------------------------------------
	var objResultSheet = objOutSheets.Add(objOutSheets(1));
	objResultSheet.Name = "比較結果";
	
	// シート内の使用範囲を取得
	var uRange1 = objDiffSheet1.UsedRange;
	var uRange2 = objDiffSheet2.UsedRange;
	
	LOG("SHEET1: range=(" + uRange1.Row + "," + uRange1.Column + "), (" +
		(uRange1.Row + uRange1.Rows.Count - 1) + "," + (uRange1.Column + uRange1.Columns.Count - 1) + ")");
	LOG("SHEET2: range=(" + uRange2.Row + "," + uRange2.Column + "), (" +
		(uRange2.Row + uRange2.Rows.Count - 1) + "," + (uRange2.Column + uRange2.Columns.Count - 1) + ")");
	
	var firstRow = uRange1.Row;
	var firstCol = uRange1.Column;
	var lastRow = uRange1.Row + uRange1.Rows.Count - 1;
	var lastCol = uRange1.Column + uRange1.Columns.Count - 1;
	
	var i = 1;
	for ( var r = firstRow; r <= lastRow; r++ ) {
		LOG("  (" + r + "/" + lastRow + ")...");
		for ( var c = firstCol; c <= lastCol; c++ ) {
//			LOG("cell(" + r + "," + c + ") = " + sheet.Cells(r, c).Value);
			if ( objDiffSheet1.Cells(r, c).Value != objDiffSheet2.Cells(r, c).Value )
			{
				objResultSheet.Cells(i, 1).Formula = "=HYPERLINK(\"#比較元シート１!\" & ADDRESS(" + r + "," + c + ",4))";
				objResultSheet.Cells(i, 2).Value = objDiffSheet1.Cells(r, c).Value;
				objResultSheet.Cells(i, 3).Value = objDiffSheet2.Cells(r, c).Value;
				i++;
				
				objDiffSheet1.Cells(r, c).Interior.ColorIndex = 38;
				objDiffSheet2.Cells(r, c).Interior.ColorIndex = 38;
			}
		}
	}
	
	
	//------------------------------------------
	// excel 後処理
	//------------------------------------------
	// 始めから作成されているシートを削除
    for ( var i = 0; i < count; i++ ) {
        objOutSheets(objOutSheets.Count).Delete();
	}
	// 列の幅を自動調整
	for ( var i = 1; i <= 3; i++ ) {
		objResultSheet.Cells(1, i).EntireColumn.AutoFit();
	}
	
	// 出力ファイルの保存
	var outXlsPath = resultDir + name;
	LOG("save: " + outXlsPath);
	objOutBook.SaveAs(outXlsPath);
	
	// クローズ
	objOutBook.Close();
	
	objExcel.Quit();
	objExcel = null;
	
	DebugUtil.Term();
	return 0;
}


function ReadINI( filespec )
{
	var GetLines = function( filespec, newline )
	{
		var lines = null;
		if ( fso.FileExists(filespec) ) {
			var rs = fso.OpenTextFile(filespec, 1, false, 0);
			var text = rs.ReadAll();
			rs.Close();
			lines = text.split(newline);
		} else {
			LOG("[ERROR] file not found : " + filespec);
		}
		return lines;
	};
	
	var ary = {}, line, sec = "";
	var lines = GetLines(filespec, "\r\n");
	for ( var i in lines ) {
		line = lines[i].replace(/^\s+|\s+$/g, "");
		if ( line.length == 0 || line.charAt(0) == ';' ) {
			continue;
		}
		if ( line.match(/^\[(.+)\]$/) ) {
			sec = RegExp.$1;
		}
		var delimiter = line.search("=");
		if ( delimiter != -1 ) {
			var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
			var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
			if ( sec != "" ) {
				ary[sec+"."+key] = val;
			} else {
				ary[key] = val;
			}
		}
	}
	return ary;
}
