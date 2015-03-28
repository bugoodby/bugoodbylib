var fso = new ActiveXObject("Scripting.FileSystemObject");
var oShell = new ActiveXObject("Shell.Application");

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
	
	return ExecScript(argc, argv);
}

function ExecScript( argc, argv )
{
	WScript.StdOut.WriteLine("Time (ex. 2010/01/15 00:00:00): ");
	var date = WScript.StdIn.ReadLine();
	
	for ( var i = 0; i < argc; i++ ) {
		ChangeTimeStamp(argv(i), date);
	}
}

function ChangeTimeStamp( path, date )
{
	LOG("------------------------------");
	LOG(path);
	
	if ( ! fso.FileExists(path) ) {
		LOG("[ERROR] file not found");
		return false;
	}
	var f = fso.GetFile(path);
	
	LOG("<before>");
	LOG("  DateCreated      : " + f.DateCreated);
	LOG("  DateLastModified : " + f.DateLastModified);
	LOG("  DateLastAccessed : " + f.DateLastAccessed);
	
	var shellFolder = oShell.NameSpace(f.ParentFolder.Path);
	var shellFile = shellFolder.ParseName(f.Name);
	shellFile.ModifyDate = date;
	
	LOG("<after>");
	LOG("  DateCreated      : " + f.DateCreated);
	LOG("  DateLastModified : " + f.DateLastModified);
	LOG("  DateLastAccessed : " + f.DateLastAccessed);
	
	return true;
}


function LOG( str )
{
	WScript.Echo(str);
}

