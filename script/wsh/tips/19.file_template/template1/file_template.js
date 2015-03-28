var fso = new ActiveXObject("Scripting.FileSystemObject");

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
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	genFileFromTemplate();
}

function genFileFromTemplate()
{
	var tmpl = WScript.ScriptFullName.replace(WScript.ScriptName, "template.txt");
	var outfile = WScript.ScriptFullName.replace(WScript.ScriptName, "outfile.txt");
	
	if ( !fso.FileExists(tmpl) ) {
		WScript.Echo("[ERROR] file not found : " + tmpl);
		return false;
	}
	
	var rs = fso.OpenTextFile( tmpl, 1/*ForReading*/, false, 0 );
	var ws = fso.OpenTextFile( outfile, 2/*ForWriting*/, true, 0 );
	var line = "";
	
	do {
		line = rs.ReadLine();
		if ( line.indexOf("HOGEHOGE") != -1 ) {
			line = line.replace("HOGEHOGE", "this is a replaced text.");
		}
		ws.WriteLine(line);
	} while ( !rs.AtEndOfStream );
	
	rs.close();
	ws.close();
	
	return true;
}

