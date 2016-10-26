//================================
var g_isCheck3 = true;

// 設定：対象にしたいパッケージが含む文字列（空なら全部）
var g_targetList_TEST = [
	"doraemon",
	"abc"
];
//================================


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
var xlPasteAll				= -4104;	//すべて
var xlPasteFormulas			= -4123;	//数式
var xlPasteValues			= -4163;	//値
var xlPasteFormats			= -4122;	//書式
var xlPasteComments			= -4144;	//コメント
var xlDataValidation		= 6;		//入力規則
var xlPasteAllExceptBorders = 7;		//罫線を除くすべて
var xlPasteColumnWidths 	= 8;		//列幅

//-- 罫線の位置 --
var xlEdgeLeft				= 7;
var xlEdgeTop				= 8;
var xlEdgeBottom			= 9;
var xlEdgeRight				= 10;
var xlInsideVertical		= 11;
var xlInsideHorizontal		= 12;
//-- 罫線の種類 --
var xlContinuous			= 1;
var xlDash					= -4115;
var xlDashDot				= 4;
var xlDashDotDot			= 5;
var xlDot					= -4118;
var xlDouble				= -4119;
//-- 罫線の太さ --
var xlHairLine				= 1;
var xlThin					= 2;
var xlThick					= 4;
var xlMedium				= -4138;
//-----------------------------------------------------------

var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");

//------------------------------------------------
WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	// WScriptならCScriptで起動し直し
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var strCmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			strCmd += " \"" + argv(i) + "\"";
		}
		strCmd += " & pause"
		return wshShell.Run(strCmd, 1, true);
	}
	
	return ExecScript(argc, argv);
}

function ExecScript( argc, argv )
{
	var plList = [
		WScript.ScriptFullName.replace(WScript.ScriptName, "test1.txt"),
		WScript.ScriptFullName.replace(WScript.ScriptName, "test2.txt")
	];
	
	AnalyzePackageList(plList);
	
	return 0;
}

function AnalyzePackageList( plList )
{
	var pm = new PackageListManager();
	
	for ( var i in plList ) {
		pm.ReadPackageList(plList[i]);
	}
	
	pm.MakeExcel("01_all", null);
	pm.MakeExcel("02_test", g_targetList_TEST);

	pm.MakeHtml("01_all", null);
	pm.MakeHtml("02_test", g_targetList_TEST);
}


//------------------------------------------------
// PackageListManager Class
//------------------------------------------------
function PackageListManager()
{
	var COMP_SAME = 0;
	var COMP_OLD = 1;
	var COMP_NEW = 2;
	var COMP_REPACK = 3;
	
	var plAry = new Array();
	var plCount = 0;
	var db = new Array();
	var rootDir = WScript.ScriptFullName.replace(WScript.ScriptName, "");
	var resultDir = rootDir + "result\\";
	var rule = null;
	
	this.fnMakeArray = null;
	this.fnCompVer = null;
	this.fnGetVerString = null;
	
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	};
	
	var GetLines = function( filespec )
	{
		var lines = null;
		if ( fso.FileExists(filespec) ) {
			var rs = fso.OpenTextFile(filespec, 1, false, 0);
			var text = rs.ReadAll();
			rs.Close();
			lines = text.split(/\r\n/);
		} else {
			LOG("[ERROR] file not found : " + filespec);
		}
		return lines;
	};
	
	this.init = function()
	{
		// 出力フォルダ作成
		if ( !fso.FolderExists(resultDir) ) {
			fso.CreateFolder(resultDir);
			LOG("created " + resultDir);
		}
		
		rule = new RegExp("^(.+-PKG-[A-Z0-9\-]+)-([0-9]+).([0-9]+).([0-9]+)-(.+).rpm");
		//レコード作成関数
		this.fnMakeArray = function( line ) {
			if ( line.match(rule) ) {
				var val = new Array(parseInt(RegExp.$2), parseInt(RegExp.$3), parseInt(RegExp.$4), RegExp.$5);
				this.UpdateRecord(RegExp.$1, val);
			} else {
				LOG("[ERROR] unmatch : " + line);
			}
		};
		//バージョン比較関数
		this.fnCompVer = function( prev, next ) {
			if ( prev[0] > next[0] ) {
				return COMP_OLD;
			} else if ( prev[0] < next[0] ) {
				return COMP_NEW;
			} else {
				if ( prev[1] > next[1] ) {
					return COMP_OLD;
				} else if ( prev[1] < next[1] ) {
					return COMP_NEW;
				} else {
					if ( prev[2] > next[2] ) {
						return COMP_OLD;
					} else if ( prev[2] < next[2] ) {
						return COMP_NEW;
					} else {
						if ( g_isCheck3 && prev[3] != next[3] ) {
							return COMP_REPACK;
						}
						return COMP_SAME;
					}
				}
			}
		};
		//表示文字列作成関数
		this.fnGetVerString = function( ary ) {
			return ary[0] + "." + ary[1] + "." + ary[2] + "-" + ary[3];
		};
	}
	
	this.UpdateRecord = function( name, val )
	{
		if ( !db[name] ) {
			db[name] = new Array();
		}
		db[name][plCount] = val;
	}
	
	this.ReadPackageList = function( filespec )
	{
		//ファイルの存在チェック
		if ( !fso.FileExists(filespec) ) {
			LOG("[ERROR] file not found : " + filespec);
			return false;
		}
		plAry[plCount] = fso.GetFileName(filespec);
		
		//メモリに読み込み
		var rs = fso.OpenTextFile(filespec, 1/*ForReading*/, false, 0);
		var text = rs.ReadAll();
		rs.Close();
		var lines = text.split(/\n/);
		
		for ( var i in lines ) {
			if ( lines[i].length == 0 || lines[i].charAt(0) == '#' ) {
				continue;
			}
			this.fnMakeArray(lines[i]);
		}
		plCount++;
		return true;
	}
	
	this.MakeExcel = function( name, table )
	{
		var Row_Header 		= 1;		//ヘッダの行番号
		var Column_Name		= 1;		//pkg名称を表示する列
		var Column_Ver		= 2;		//ver表記の開始列
		
		//行番号、列番号からRangeオブジェクトを取得する関数
		function getRange( objSheet, row_s, col_s, row_e, col_e )
		{
			return objSheet.Range(objSheet.Cells(row_s, col_s).address,
								objSheet.Cells(row_e, col_e).address);
		}
		//セルに罫線を引く関数
		function rulingRange( range )
		{
			var borders = [ xlEdgeLeft, xlEdgeRight, xlEdgeTop, xlEdgeBottom,
							xlInsideVertical, xlInsideHorizontal ];
			for ( var i in borders ) {
				var border = range.Borders(borders[i]);
				border.Weight = xlThin;
				border.LineStyle = xlContinuous;
			}
		}
		//指定した名称が対象リストに含まれるかチェック
		function isTarget( targetList, name ) {
			if ( !targetList ) { return true; }
			for ( var i in targetList ) {
				if ( name.indexOf(targetList[i]) != -1 ) {
					return true;
				}
			}
			return false;
		}
		
		if ( !table ) LOG_ARRAY(db);	//1回だけ出す
		
		//------------------------------------------
		// excel 前処理
		//------------------------------------------
		// Excelオブジェクトの作成
		var objExcel = new ActiveXObject("Excel.Application");
		objExcel.Visible = true;			// ウィンドウ表示
		objExcel.DisplayAlerts = false;		// アラート停止
		
		// 出力ファイルを新規作成
		var objOutBook = objExcel.Workbooks.Add();
		var objOutSheet = objOutBook.Worksheets(1);
		objOutSheet.Select();

		//------------------------------------------
		// excel 本処理
		//------------------------------------------
		// ヘッダ行
		objOutSheet.Cells(Row_Header, Column_Name).Value = "Name";
		for ( var j = 0; j < plCount; j++ ) {
			objOutSheet.Cells(Row_Header, Column_Ver + j).Value = plAry[j];
		}
		rulingRange(getRange(objOutSheet, Row_Header, Column_Name, Row_Header, Column_Ver + plCount - 1));
		
		// 各pkgの行
		var i = Row_Header + 1;
		for ( var key in db ) {
			if ( !isTarget(table, key) ) continue;
			objOutSheet.Cells(i, Column_Name).Value = key;
			objOutSheet.Cells(i, Column_Name).Formula = '=HYPERLINK("' + key + '", "' + key + '")';
			
			for ( var j = 0; j < plCount; j++ ) {
				if ( !db[key][j] ) {
					objOutSheet.Cells(i, Column_Ver + j).Interior.Color = RGB(217,217,217);
				} else {
					objOutSheet.Cells(i, Column_Ver + j).Value = this.fnGetVerString(db[key][j]);
					if ( db[key][j+1] ) {
						//比較結果でセルに色づけ
						var cmp = this.fnCompVer(db[key][j+1], db[key][j]);
						switch ( cmp ) {
						case COMP_OLD:		objOutSheet.Cells(i, Column_Ver + j).Interior.Color = RGB(255,0,51);	break;
						case COMP_NEW:		objOutSheet.Cells(i, Column_Ver + j).Interior.Color = RGB(0,255,102);	break;
						case COMP_REPACK:	objOutSheet.Cells(i, Column_Ver + j).Interior.Color = RGB(255,255,128);	break;
						default:																					break;
						}
					}
				}
			}
			rulingRange(getRange(objOutSheet, i, Column_Name, i, Column_Ver + plCount - 1));
			i++;
		}
		
		//------------------------------------------
		// excel 後処理
		//------------------------------------------
		var firstCol = Column_Name;
		var lastCol = objOutSheet.Cells(Row_Header, firstCol).End(xlToRight).Column;
		var rs = objOutSheet.Cells(Row_Header, firstCol).address;
		var re = objOutSheet.Cells(Row_Header, lastCol).address;
		
		// ヘッダの色付け
		objOutSheet.Range(rs, re).Interior.Color = RGB(253,233,217);
		// 列の幅を自動調整
		for ( var i = firstCol; i <= lastCol; i++ ) {
			objOutSheet.Cells(1, i).EntireColumn.AutoFit();
		}
		// オートフィルタの設定
		var range = objOutSheet.Cells(Row_Header, 1).EntireRow;
		range.AutoFilter();
		// ウィンドウ枠の固定
		objOutSheet.Cells(Row_Header + 1, Column_Name + 1).Select();
		objExcel.ActiveWindow.FreezePanes = true;
		
		// 出力ファイルの保存
		var outXlsPath = resultDir + name + ".xls";
	    objOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
		LOG("save: " + outXlsPath);
		
		// クローズ
		objOutBook.Close();
		objExcel.Quit();
		
		// オブジェクトの破棄
		objExcel = null;
	};
	
	this.MakeHtml = function( name, table )
	{
		//現在日時の文字列を返す
		function getTodayStr() {
			var today = new Date();
			return (today.getYear() + "/" + (today.getMonth() + 1) + "/" + today.getDate() + " "
					+ today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds());
		}
		//指定した名称が対象リストに含まれるかチェック
		function isTarget( targetList, name ) {
			if ( !targetList ) { return true; }
			for ( var i in targetList ) {
				if ( name.indexOf(targetList[i]) != -1 ) {
					return true;
				}
			}
			return false;
		}
		
		if ( !table ) LOG_ARRAY(db);	//1回だけ出す
		
		//------------------------------------------
		// html 前処理
		//------------------------------------------
		//出力ファイルの準備
		var outHtmPath = resultDir + name + ".htm";
		var ws = fso.OpenTextFile(outHtmPath, 2/*ForWriting*/, true, 0);
		
		// HTMLテンプレート読み込み
		var htmlLines = GetLines(WScript.ScriptFullName.replace(WScript.ScriptName, "template.htm"));
		
		var i = 0;
		while ( i < htmlLines.length ) {
			if ( htmlLines[i].match("<!-- CONTENTS -->") ) {
				i++;
				break;
			}
			ws.WriteLine(htmlLines[i++]);
		}
		
		//------------------------------------------
		// html 本処理
		//------------------------------------------
		ws.WriteLine("<div>last update: " + getTodayStr() + "</div>");
		ws.WriteLine("<table>");
		// ヘッダ行
		ws.WriteLine("\t<tr>");
		ws.WriteLine("\t\t<th>Name</th>");
		for ( var j = 0; j < plCount; j++ ) {
			ws.WriteLine("\t\t<th>" + plAry[j] + "</th>");
		}
		ws.WriteLine("\t</tr>");
		// 各pkgの行
		for ( var key in db ) {
			if ( !isTarget(table, key) ) continue;
			ws.WriteLine("\t<tr class=\"pkg\">");
			ws.WriteLine("\t\t<td class=\"pn\"><a href=\"" + key + "\" target=\"_blank\">" + key + "</a></td>");
			for ( var j = 0; j < plCount; j++ ) {
				if ( !db[key][j] ) {
					ws.WriteLine("\t\t<td bgcolor=\"D9D9D9\"></td>");
				} else {
					if ( db[key][j+1] ) {
						//比較結果でセルに色づけ
						var cmp = this.fnCompVer(db[key][j+1], db[key][j]);
						switch ( cmp ) {
						case COMP_OLD:		ws.WriteLine("\t\t<td bgcolor=\"FF0033\">" + this.fnGetVerString(db[key][j]) + "</td>");	break;
						case COMP_NEW:		ws.WriteLine("\t\t<td bgcolor=\"00FF66\">" + this.fnGetVerString(db[key][j]) + "</td>");	break;
						case COMP_REPACK:	ws.WriteLine("\t\t<td bgcolor=\"FFFF80\">" + this.fnGetVerString(db[key][j]) + "</td>");	break;
						default:			ws.WriteLine("\t\t<td>" + this.fnGetVerString(db[key][j]) + "</td>");						break;
						}
					} else {
						ws.WriteLine("\t\t<td>" + this.fnGetVerString(db[key][j]) + "</td>");
					}
				}
			}
			ws.WriteLine("\t</tr>");
		}
		ws.WriteLine("</table>");
		
		//------------------------------------------
		// html 後処理
		//------------------------------------------
		while ( i < htmlLines.length ) {
			ws.WriteLine(htmlLines[i++]);
		}
		
		ws.Close();
		LOG("save: " + outHtmPath);
	};
	
	this.init();
}

function LOG( str ) {
	WScript.Echo(str);
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}

