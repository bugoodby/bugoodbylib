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


WScript.Quit(main(WScript.Arguments.Count(), WScript.Arguments));

function main( argc, argv ) 
{
	// WScriptならCScriptで起動し直し
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	DebugUtil.Init("both");
	
	read_ini("non_exist_file.ini");
	read_ini(WScript.ScriptFullName.replace(WScript.ScriptName, "test.ini"));
	read_ini_sec(WScript.ScriptFullName.replace(WScript.ScriptName, "test.ini"));
	read_ini_sec2(WScript.ScriptFullName.replace(WScript.ScriptName, "test.ini"));
	
	DebugUtil.Term();
}

// セクションを無視し、単純に key = val だけ抽出して配列に格納
function read_ini( filespec )
{
	var ReadINI = function( filespec )
	{
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
		
		var ary = {}, line;
		var lines = GetLines(filespec, "\r\n");
		for ( var i in lines ) {
			line = lines[i].replace(/^\s+|\s+$/g, "");
			if ( line.length == 0 || line.charAt(0) == ';' ) {
				continue;
			}
			var delimiter = line.search("=");
			if ( delimiter != -1 ) {
				var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
				var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
				ary[key] = val;
			}
		}
		return ary;
	}
	
	LOG(filespec);
	var ini = ReadINI(filespec);
	LOG_ARRAY(ini);
}

// セクションを意識し、"section.key"の形式で配列のインデックスに格納
function read_ini_sec( filespec )
{
	var ReadINI = function( filespec )
	{
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
	
	LOG(filespec);
	var ini = ReadINI(filespec);
	LOG_ARRAY(ini);
}

// セクション毎に配列を生成して格納
function read_ini_sec2( filespec )
{
	var ReadINI = function( filespec )
	{
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
		
		var ary = {}, line, sec = "";
		var lines = GetLines(filespec, "\r\n");
		for ( var i in lines ) {
			line = lines[i].replace(/^\s+|\s+$/g, "");
			if ( line.length == 0 || line.charAt(0) == ';' ) {
				continue;
			}
			if ( line.match(/^\[(.+)\]$/) ) {
				sec = RegExp.$1;
				ary[sec] = {};
			}
			var delimiter = line.search("=");
			if ( delimiter != -1 ) {
				var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
				var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
				if ( sec != "" ) {
					ary[sec][key] = val;
				}
			}
		}
		return ary;
	}
	
	LOG(filespec);
	var ini = ReadINI(filespec);
	for ( var i in ini ) {
		LOG("[" + i + "]");
		LOG_ARRAY(ini[i]);
	}
}

