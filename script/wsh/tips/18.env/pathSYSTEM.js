var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");


WScript.Quit(main(WScript.Arguments.Count(), WScript.Arguments));

function main( argc, argv ) 
{
	//UAC¸Ši
	(function(){
		var key = "_!!!_uac_mode_!!!_";
		
		var sVer = fso.GetFileVersion(fso.BuildPath(fso.GetSpecialfolder(1).Path, "kernel32.dll"));
		var nVer = parseInt(sVer);
		if ( nVer >= 6 ) {
			var args = (function(){
				args = [];
				for ( var e = new Enumerator(WScript.Arguments); !e.atEnd(); e.moveNext() ) { args.push(e.item()); }
				return args;
			})();
			if ( args[args.length - 1] != key ) {
				args.push(key);
				var sh = new ActiveXObject("Shell.Application");
				sh.ShellExecute("wscript.exe", "\"" + WScript.ScriptFullName + "\" "+ args.join(" "), "", "runas", 1);
				WScript.Quit(0);
			}
		}
	})();
	
	if ( argc == 1 ) {
		GetPath();
	} else {
		SetPath(argv(0));
	}
}


function GetPath()
{
	var pathlist = WScript.ScriptFullName.replace(WScript.ScriptName, "pathSYSTEM.txt");
	
	var wshSysEnv = wshShell.Environment("SYSTEM");
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
	
	var wshSysEnv = wshShell.Environment("SYSTEM");
	wshSysEnv("PATH") = str;
}

