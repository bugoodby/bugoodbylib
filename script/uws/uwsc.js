var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
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
	var ret = true;
	var root = WScript.ScriptFullName.replace(WScript.ScriptName, "");
	
	exec_uwsc(root + "ShowAllWndInfo.uws", "");
}


function exec_uwsc( script, args )
{
	var uwsc = "C:\\app\\uwsc.exe";
	
	if ( ! fso.FileExists(uwsc) ) {
		LOG("[ERROR] file not found : " + uwsc)
		return false;
	}
	var wshShell = new ActiveXObject("WScript.Shell");
	var cmd = "\"" + uwsc + "\" \"" + script + "\" " + args;
	LOG("[exec] " + cmd);
	wshShell.Run(cmd, 1, true);
	return true;
}


function LOG( str )
{
	WScript.Echo(str);
}
