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
var wshShell = new ActiveXObject("WScript.Shell");


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
	
	//-------------------------------------------------
	// setŒo—R
	var env1 = getEnvironmentVariables();
	LOG_ARRAY(env1);
	
	//-------------------------------------------------
	// WshEnvironment
	var keys = [
		"NUMBER_OF_PROCESSORS",
		"PROCESSOR_ARCHITECTURE",
		"PROCESSOR_IDENTIFIER",
		"PROCESSOR_LEVEL",
		"PROCESSOR_REVISION",
		"OS",
		"COMSPEC",
		"HOMEDRIVE",
		"HOMEPATH",
		"PATH",
		"PATHEXT",
		"PROMPT",
		"SYSTEMDRIVE",
		"SYSTEMROOT",
		"WINDIR",
		"TEMP",
		"TMP"
	];
	var wshSysEnv = wshShell.Environment("SYSTEM");
	LOG("SYSTEM:  length = " + wshSysEnv.length);
	for ( var i in keys ) {
		LOG("   " + keys[i] + " : " + wshSysEnv(keys[i]));
	}
	var wshUsrEnv = wshShell.Environment("USER");
	LOG("USER:    length = " + wshUsrEnv.length);
	for ( var i in keys ) {
		LOG("   " + keys[i] + " : " + wshUsrEnv(keys[i]));
	}
	var wshPrcEnv = wshShell.Environment("PROCESS");
	LOG("PROCESS: length = " + wshPrcEnv.length);
	for ( var i in keys ) {
		LOG("   " + keys[i] + " : " + wshPrcEnv(keys[i]));
	}
	
	//-------------------------------------------------
	// Path‘€ì
	var pa = wshSysEnv("PATH").split(";");
	LOG_ARRAY(pa);
	
	DebugUtil.Term();
}


function getEnvironmentVariables()
{
	var envlist = WScript.ScriptFullName.replace(WScript.ScriptName, "envlist.txt");
	wshShell.Run("cmd.exe /c set > \"" + envlist + "\"", 1, true);
	WScript.Sleep(500);
	
	var rs = fso.OpenTextFile(envlist, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split("\r\n");
	
	var ary = {};
	for ( var i in lines ) {
		var delimiter = lines[i].search("=");
		if ( delimiter != -1 ) {
			var key = lines[i].slice(0, delimiter).replace(/^\s+|\s+$/g, "");
			var val = lines[i].slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
			ary[key] = val;
		}
	}
	return ary;
}

