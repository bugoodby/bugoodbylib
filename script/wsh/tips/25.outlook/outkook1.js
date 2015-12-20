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
	var olFolderInbox = 6;
	
	var objOutlook = new ActiveXObject("Outlook.Application");
	var objNAMESPC = objOutlook.GetNamespec("MAPI");
	
	var myfolder = objNAMESPC.GetDefaultFolder(olFolderInbox).Folders("SubFolder");
	
	for ( var i = 1; i < myfolder.Items.Count; i++ ) {
		if ( (myfolder.Items(i).Subject.IndexOf("xxx") == 0)
			&& (myfolder.Items(i).ReceivedTime.getYear() == 2015) ) {
			WScript.Echo(myfolder.Items(i).Sender);
		}
	}
}
