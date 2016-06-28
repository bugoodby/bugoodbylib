var fso = new ActiveXObject("Scripting.FileSystemObject");


main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("[ERROR] à¯êîÇ™ïsê≥Ç≈Ç∑");
		return -1;
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
	if ( fso.FolderExists(path) )
	{
		var fe = new FileEnumerator(/\.(js|vbs)$/);
		fe.enumerate( path );
		
		for ( var i in fe.list ) {
			LOG( fe.list[i] );
			testFunc( fe.list[i] );
		}
	}
	else
	{
		testFunc( path );
	}
	
	return 0;
}

function testFunc( f )
{
	LOG("  " + fso.GetBaseName(f));
	LOG("  " + "extension = " + fso.GetExtensionName(f));
	return true;
}

function FileEnumerator( filter )
{
	this.filter = filter || ".*";
	this.list = new Array();
	
	var enumerate_sub = function( lst, folder )
	{
		var d = fso.GetFolder(folder);
		var subdirs = new Enumerator(d.SubFolders);
		var files = new Enumerator(d.files);
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( files.item().Path.match(filter) ) { 
				lst.push(files.item().Path);
			}
		}
		for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
			enumerate_sub(lst, subdirs.item().Path);
		}
	}
	this.enumerate = function( folder )
	{
		var lst = new Array();
		enumerate_sub(lst, folder);
		this.list = lst;
	}
}

function LOG( str )
{
	WScript.Echo(str);
}
