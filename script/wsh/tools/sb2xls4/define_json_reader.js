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
	var filespec = WScript.ScriptFullName.replace(WScript.ScriptName, "define.json");
	var def = eval( fso.OpenTextFile( filespec, 1 ).ReadAll() );
	
	for ( var groupID in def ) {
		LOG(groupID);
		for ( var recordID in def[groupID] ) {
			LOG("  " + recordID);
			LOG("    " + def[groupID][recordID].TrackID);
		}
	}
}

function LOG( str )
{
	WScript.Echo(str);
}

function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
