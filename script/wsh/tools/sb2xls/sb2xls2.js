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
	var outfile = WScript.ScriptFullName.replace(WScript.ScriptName, "output.csv");
	var ws = fso.OpenTextFile( outfile, 2/*ForWriting*/, true, 0 );
	
	var db = new CsvDataBase(filespec);
	db.SUMIF1(ws, "タイトル行", "大項目１");
	db.SUMIF2(ws, "タイトル行", "大項目１", "名称", "ほげほげ");
	db.SUMIF2(ws, "タイトル行", "大項目１", "名称", "ふがふが");
	db.SUMIF2(ws, "タイトル行", "大項目１", "名称", "ぴよぴよ");
	
	db.enumSUMIF1(ws, "タイトル行", "大項目１");
	
	ws.close();
}

function CsvDataBase( filespec )
{
	var m_headerTbl = {};
	var m_dataTbl = [];
	
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
	
	var ReadCSV = function( filespec )
	{
		LOG("> CsvDataBase.ReadCSV()");
		
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
	}
	
	var FormatItem = function( str )
	{
		var s = str.replace(/^\s+|\s+$/g, "")
		if ( s.length > 1 && s.slice(0, 1) == "\"" && s.slice(-1) == "\"" ) {
			s = s.slice(1, s.length - 1)
		}
		return s;
	}
	
	LOG(filespec);
	ReadCSV(filespec);
	
	this.SUMIF1 = function( ws, key, val )
	{
		var result = 0;
		for ( var i in m_dataTbl ) {
			if ( m_dataTbl[i][m_headerTbl[key]] == val ) {
				result += parseFloat(m_dataTbl[i][m_headerTbl["結果"]]);
			}
		}
		ws.WriteLine(key + "=" + val + "," + result);
		return result;
	}
	
	this.SUMIF2 = function( ws, key1, val1, key2, val2 )
	{
		var result = 0;
		for ( var i in m_dataTbl ) {
			if ( (m_dataTbl[i][m_headerTbl[key1]] == val1)
				&& (m_dataTbl[i][m_headerTbl[key2]] == val2) ) {
				result += parseFloat(m_dataTbl[i][m_headerTbl["結果"]]);
			}
		}
		ws.WriteLine(key1 + "=" + val1 + " && " + key2 + "=" + val2 + "," + result);
		return result;
	}
	
	this.enumSUMIF1 = function( ws, key1, val1 )
	{
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
		for ( var i in results ) {
			ws.WriteLine(key1 + "=" + val1 + " && " + "ID=" + i + "," + results[i]);
		}
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
