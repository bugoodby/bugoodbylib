main( WScript.Arguments.Count(), WScript.Arguments );

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
	var user = "";
	var pass = "";
	
	WScript.StdOut.WriteLine("USER: ");
	user = WScript.StdIn.ReadLine();
	WScript.StdOut.WriteLine("PASS: ");
	pass = WScript.StdIn.ReadLine();
	
	WScript.Echo("user=" + user + "\npass=" + pass);
}

