var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("[ERROR] 引数が不正です");
		return -1;
	}
	// WScriptならCScriptで起動し直し
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

function ExecScript( folder )
{
	var fe = new FileEnumerator();
	
	fe.setFilter("\.(js|vbs)$")
	fe.enumerate(folder);
	fe.list();
	fe.exec(testFunc);
	
	return 0;
}

function testFunc( f )
{
	WScript.Echo("extension = " + fso.GetExtensionName(f));
	return true;
}

//------------------------------------------------
// FileEnumerator Class
//------------------------------------------------
function FileEnumerator( filter )
{
	var ft = filter || ".*";
	var fl = [];
	
	var enumerate_sub = function( folder )
	{
		var d = fso.GetFolder(folder);
		var subdirs = new Enumerator(d.SubFolders);
		var files = new Enumerator(d.files);
		
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( files.item().Path.match(ft) ) {
				fl.push(files.item().Path);
			}
		}
		for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
			enumerate_sub(subdirs.item().Path);
		}
	}
	
	// ファイル列挙のフィルターを設定する
	this.setFilter = function( filter )
	{
		ft = filter;
	}
	
	// 指定フォルダ内のファイルを列挙し、内部リストを生成
	this.enumerate = function( folder )
	{
		fl.length = 0;
		enumerate_sub(folder);
	}
	
	// 内部リストのファイル一覧を表示
	this.list = function()
	{
		var s = "";
		for ( var i in fl ) {
			s += i + " : " + fl[i] + "\n";
		}
		WScript.Echo(s);
	}
	
	// 内部リストの各ファイルに対してfuncを実行
	this.exec = function( callback )
	{
		for ( var i in fl ) {
			if ( callback(fl[i]) == false ) {
				return false;
			}
		}
		return true;
	}
}
