var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("ïsê≥Ç»à¯êîÇ≈Ç∑");
		return 0;
	}
	// WScriptÇ»ÇÁCScriptÇ≈ãNìÆÇµíºÇµ
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript( argv(0) );
}

function ExecScript( path )
{
	if ( fso.FolderExists(path) )
	{
		var fe = new FileEnumerator(/\.(js|vbs)$/);
		fe.enumlate( path );
		
		for ( var i in fe.list ) {
			LOG( fe.list[i] );
			ModifyTextFile( fe.list[i] );
		}
	}
	else
	{
		ModifyTextFile( path );
	}
	return 0;
}

function ModifyTextFile( filespec )
{
	var ins1 = WScript.ScriptFullName.replace(WScript.ScriptName, "insert.txt");
	
	if ( !fso.FileExists(filespec) ) {
		LOG("[ERROR] file not found : " + filespec);
		return;
	}
	
	var rs = fso.OpenTextFile( filespec, 1/*ForReading*/, false, 0 );
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split("\r\n");
	
	var ws = fso.OpenTextFile( filespec, 2/*ForWriting*/, true, 0 );
	for ( var i in lines ) 
	{
		lines[i] = lines[i].replace("HOGEHOGE", "this is a replaced text.");
		
		if ( lines[i].match(/^(PROJECT_NAME\s*=)/) ) 
		{
			LOG("match yyy !");
			ws.WriteLine(RegExp.$1 + " " + prjName);
		}
		else if ( lines[i].match("^function ExecScript()") ) 
		{
			LOG("match xxx !");
			var rs2 = fso.OpenTextFile( ins1, 1/*ForReading*/, false, 0 );
			var text2 = rs2.ReadAll();
			rs2.Close();
			ws.WriteLine(text2);
		}
		ws.WriteLine(lines[i]);
	}
	ws.close();
}

function FileEnumerator( filter )
{
	this.filter = filter || ".*";
	this.list = [];
	
	var enumerate_sub = function( folder )
	{
		var d = fso.GetFolder(folder);
		var subdirs = new Enumerator(d.SubFolders);
		var files = new Enumerator(d.files);
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( files.item().Path.match(ft) ) { this.list.push(files.item().Path); }
		}
		for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
			enumerate_sub(subdirs.item().Path);
		}
	}
	this.enumerate = function( folder )
	{
		this.list.length = 0;
		enumerate_sub(folder);
	}
}

function LOG( str )
{
	WScript.Echo(str);
}
