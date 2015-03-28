var wshShell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");

WScript.Quit(main(WScript.Arguments.Count(), WScript.Arguments));

function main( argc, argv ) 
{
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
	var baseDir = "D:\\mydoc\\Documents\\Virtual Machines\\";
	var ttpmacro = "D:\\mydoc\\Documents\\app\\TeraTerm\\teraterm-4.79\\teraterm-4.79\\ttpmacro.exe";
	var macropath = WScript.ScriptFullName.replace(WScript.ScriptName, "test.ttl");
	var url = "https://www.google.com/";
	
	var src = baseDir + "PuppyLinux";
	var dst = baseDir + "PuppyLinux_copy";
	
	if ( fso.FolderExists(dst) ) {
		LOG("[del] " + dst + "\\*");
		fso.DeleteFile(dst + "\\*", true);
	} else {
		LOG("[create] " + dst);
		fso.CreateFolder(dst);
	}
	
	LOG("[copy] " + src + " -> " + dst);
	fso.CopyFolder(src, dst);
	WScript.Sleep(1000);
	
	LOG("VMwarePlayer ‹N“®’†...");
	wshShell.Run("\"" + dst + "\\PuppyLinux.vmx" + "\"", 1, false);
	WScript.Sleep(30000);
	
	LOG("VitualMachine ‹N“®’†...");
	wshShell.AppActivate(" - VMware Player");
	wshShell.SendKeys("%P"); // Alt+P
	WScript.Sleep(30000);
	
	LOG("TeraTerm‹N“®...");
	var cmd = "\"" + ttpmacro + "\" \"" + macropath + "\" \"" + url + "\"";
	wshShell.Run(cmd, 1, false);
}

function LOG( str )
{
	WScript.Echo(str);
}
