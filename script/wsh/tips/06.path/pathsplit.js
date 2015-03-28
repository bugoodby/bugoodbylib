var wshShell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("à¯êîÇ™ïsê≥Ç≈Ç∑");
		return 1;
	}
	
	// WScriptÇ»ÇÁCScriptÇ≈ãNìÆÇµíºÇµ
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function ExecScript( path )
{
	var dir = fso.GetParentFolderName(path);
	var parts = dir.split("\\");
	
	WScript.Echo("------------------");
	for ( var i in parts ) {
		WScript.Echo(parts[i]);
	}
	
	WScript.Echo("------------------");
	var cnt = parts.length;
	WScript.Echo("parent name: " + parts[cnt-1]);
}


