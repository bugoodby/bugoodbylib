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
	// WScript‚È‚çCScript‚Å‹N“®‚µ’¼‚µ
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
	
	read_csv(WScript.ScriptFullName.replace(WScript.ScriptName, "test1.csv"));
	read_csv(WScript.ScriptFullName.replace(WScript.ScriptName, "test2.csv"));
	
	DebugUtil.Term();
}

function read_csv( filespec )
{
	LOG(filespec);
	var csv = ReadCSV(filespec);
	for ( var i in csv ) {
		LOG("[" + i + "]");
		LOG_ARRAY(csv[i]);
	}
}

function ReadCSV( filespec )
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
	var FormatItem = function( str ) {
		var s = str.replace(/^\s+|\s+$/g, "")
		if ( s.length > 1 && s.slice(0, 1) == "\"" && s.slice(-1) == "\"" ) {
			s = s.slice(1, s.length - 1)
		}
		return s;
	}
	var ary = [], line;
	var lines = GetLines(filespec, "\r\n");
	for ( var i in lines ) {
		line = lines[i].replace(/^\s+|\s+$/g, "");
		if ( line.length == 0 ) {
			continue;
		}
		var items = line.split(",")
		for ( var i in items ) {
			items[i] = FormatItem(items[i]);
		}
		ary.push(items)
	}
	return ary;
}

