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
	
	if ( argc == 0 ) {
		GetPath();
	} else {
		SetPath(argv(0));
	}
}


function GetPath()
{
	var pathlist = WScript.ScriptFullName.replace(WScript.ScriptName, "pathUSER.txt");
	
	var wshSysEnv = wshShell.Environment("USER");
	var pa = wshSysEnv("PATH").split(";");
	var ws = fso.OpenTextFile(pathlist, 2, true, 0);
	for ( var i in pa ) {
		ws.WriteLine(pa[i]);
	}
	ws.close();
}

function SetPath( file )
{
	var rs = fso.OpenTextFile(file, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split("\r\n");
	
	var str = "";
	for ( var i in lines ) {
		var p = lines[i].replace(/^\s+|\s+$/g, "");
		if ( p.length > 0 ) {
			if ( str.length > 0 ) str += ";";
			str += p;
		}
	}
	WScript.Echo(str);
	
	var wshSysEnv = wshShell.Environment("USER");
	wshSysEnv("PATH") = str;
}

