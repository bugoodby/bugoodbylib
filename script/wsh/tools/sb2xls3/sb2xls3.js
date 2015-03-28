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
	
	return ExecScript();
}

function ExecScript()
{
	targetIDs = [];
	
	var dataFile = WScript.ScriptFullName.replace(WScript.ScriptName, "_source.csv");
	var mainFile = WScript.ScriptFullName.replace(WScript.ScriptName, "_main.xlsx");
	var defFile = WScript.ScriptFullName.replace(WScript.ScriptName, "_define.xlsx");
	
	var db = new CsvDataBase();
	db.exec(mainFile, dataFile, defFile);
}

function CsvDataBase()
{
	var m_headerTbl = {};		// ReadCSV() 結果
	var m_dataTbl = [];			// ReadCSV() 結果
	var m_targetIDs = [];
	var m_descriptions = {};
	
	//---------------------------------------------------------------
	var ReadCSV = function( filespec )
	{
		LOG("> CsvDataBase.ReadCSV()");
		
		var GetLines = function( filespec, newline ) {
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
		
		var FormatItem = function( str ) {
			var s = str.replace(/^\s+|\s+$/g, "")
			if ( s.length > 1 && s.slice(0, 1) == "\"" && s.slice(-1) == "\"" ) {
				s = s.slice(1, s.length - 1)
			}
			return s;
		}
		
		var lines = GetLines(filespec, "\r\n");
		
		var i = 0;
		for ( ; i < lines.length; i++ ) {
			if ( lines[i].indexOf("タイトル行") != -1 ) {
				LOG("HEADER FOUND @ line " + i);
				{
					var line = lines[i].replace(/^\s+|\s+$/g, "");
					if ( line.length == 0 ) {
						continue;
					}
					var items = line.split(",")
					for ( var j in items ) {
						items[j] = FormatItem(items[j]);
						m_headerTbl[items[j]] = j;
					}
					LOG_ARRAY(m_headerTbl);
				}
				i++
				break;
			}
		}
		for ( ; i < lines.length; i++ ) {
			var line = lines[i].replace(/^\s+|\s+$/g, "");
			if ( line.length == 0 ) {
				continue;
			}
			var items = line.split(",")
			for ( var j in items ) {
				items[j] = FormatItem(items[j]);
			}
			m_dataTbl.push(items);
		}
		LOG("ROWS : " + m_dataTbl.length);
		
		LOG("< CsvDataBase.ReadCSV()");
		return true;
	}
	
	var enumSUMIF1 = function( oSheet, key1, val1 )
	{
		LOG("> CsvDataBase.enumSUMIF1( " + key1 + ", " + val1 + " )");
		var results = {};
		for ( var i in m_dataTbl ) {
			if ( (m_dataTbl[i][m_headerTbl[key1]] == val1) ) {
				var id = m_dataTbl[i][m_headerTbl["テスト"]].substring(0, 2);
				if ( id in results ) {
					results[id] += parseFloat(m_dataTbl[i][m_headerTbl["結果"]]);
				} else {
					results[id] = parseFloat(m_dataTbl[i][m_headerTbl["結果"]]);
				}
			}
		}
		
		var row = oSheet.Cells(oSheet.Rows.Count, 1).End(xlUp).Row + 1;
		for ( var i in results ) {
			oSheet.Cells(row, 1).Value = key1;
			oSheet.Cells(row, 2).Value = val1;
			oSheet.Cells(row, 3).Value = i;
			oSheet.Cells(row, 4).Value = results[i];
			oSheet.Cells(row, 5).Value = GetDescription(val1, i);
			row++;
		}
		LOG("< CsvDataBase.enumSUMIF1()");
	}
	
	//---------------------------------------------------------------
	var ReadDescriptionTable = function( filespec )
	{
		var COL_ID = 1;		// IDの列
		var COL_SUBID = 2;	// SubIDの列
		var COL_DESC = 3;	// 詳細情報の列
		
		var isEmpty = function( hash ) {
			var cnt = 0;
			for ( var i in hash ) {
				cnt++;
			}
			if ( cnt == 0 ) return true;
			else return false;
		}
		
		var isContain = function( ary, val ) {
			for ( var i in ary ) {
				if ( ary[i] == val ) {
					return true;
				}
			}
			return false;
		}
		
		LOG("> CsvDataBase.ReadDescriptionTable()");
		try {
			// Excelオブジェクトの作成
			var objExcel = new ActiveXObject("Excel.Application");
			objExcel.Visible = true;			// ウィンドウ表示設定
			objExcel.DisplayAlerts = true;		// アラート設定
			
			// Excelファイルを開く
			var objBook = objExcel.Workbooks.Open(filespec);
			var oSheet = objBook.WorkSheets("Sheet1");
			
			// 詳細情報テーブル作成
			var lastRow = oSheet.Cells(oSheet.Rows.Count, COL_SUBID).End(xlUp).Row;
			LOG("last=(" + lastRow  + ")");
			
			var items = {};
			var curId = "";
			var isTarget = false;
			
			for ( var r = 1; r <= lastRow; r++ )
			{
				var id = oSheet.Cells(r, COL_ID).Text;
				if ( id != "" ) {
					if ( ! isEmpty(items) ) {
						LOG("ID: " + curId);
						LOG_ARRAY(items);
						m_descriptions[curId] = items;
						items = {};
					}
					curId = id;
					isTarget = isContain(m_targetIDs, curId);
				}
				if ( isTarget ) {
					var subId = oSheet.Cells(r, COL_SUBID).Text;
					var desc = oSheet.Cells(r, COL_DESC).Text;
					if ( subId != "" && desc != "" ) {
						items[subId] = desc;
					}
				}
			}
			if ( ! isEmpty(items) ) {
				LOG("ID: " + curId);
				LOG_ARRAY(items);
				m_descriptions[curId] = items;
				items = {};
			}
			
			// Excelファイルを閉じる
			objBook.Close();
			
			// Excelオブジェクトの破棄
			objExcel.Quit();
			objExcel = null;
		}
		catch (e) {
			LOG("[ERROR] " + e.description);
			return false;
		}
		
		LOG("< CsvDataBase.ReadDescriptionTable()");
		return true;
	}
	
	var GetDescription = function( id, subId )
	{
		for ( var i in m_descriptions ) {
			if ( i == id ) {
				for ( var j in m_descriptions[i] ) {
					if ( j == subId ) {
						return m_descriptions[i][j];
					}
				}
			}
		}
		return "(no description)";
	}
	
	//---------------------------------------------------------------
	this.exec = function( mainFile, dataFile, defineFile )
	{
		// Excelオブジェクトの作成
		var objExcel = new ActiveXObject("Excel.Application");
		objExcel.Visible = true;			// ウィンドウ表示設定
		objExcel.DisplayAlerts = false;		// アラート設定
		
		// Excelファイルを開く
		var objBook = objExcel.Workbooks.Open(mainFile);
		
		// 対象IDを取得
		{
			var oSheet = objBook.WorkSheets("config");
			for ( var r = 3; ; r++ ) {
				id = oSheet.Cells(r, 2).Text;
				if ( id == "" ) break;
				m_targetIDs.push(id);
			}
			LOG_ARRAY(m_targetIDs);
		}
		
		// csvデータ読み込み
		ReadCSV(dataFile);
		
		// 詳細情報読み込み
		ReadDescriptionTable(defineFile);
		
		// 出力シートをクリア
		var oSheet = objBook.WorkSheets("output");
		oSheet.Cells.Clear();
		
		// 結果を出力
		for ( var i in m_targetIDs ) {
			enumSUMIF1(oSheet, "ID", m_targetIDs[i]);
		}
		
		// Excelファイルを閉じる
		objBook.Save();
		objBook.Close();
		
		// Excelオブジェクトの破棄
		objExcel.Quit();
		objExcel = null;
		
	}
	
}

function LOG( str )
{
	WScript.Echo(str);
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
