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
	
	var aaa = root + "aaa_dir";
	var bbb = root + "bbb_dir";
	var batch = root + "aaa.bat";
	var args = "hoge hoge";
	
	LOG("+----------------------------------");
	LOG("| resultフォルダ作成");
	LOG("+----------------------------------");
	var resultDir = root + "result" + getDate() + "\\";
	ret = cleanup_folder(resultDir);
	if ( !ret ) { return 1; }
	
	
	LOG("+----------------------------------");
	LOG("| フォルダのクリーンアップ");
	LOG("+----------------------------------");
	ret = cleanup_folder(aaa);
	if ( !ret ) { return 1; }
	
	ret = cleanup_folder(bbb);
	if ( !ret ) { return 1; }
	
	
	LOG("+----------------------------------");
	LOG("| 必要なファイルコピー");
	LOG("+----------------------------------");
	ret = copy_folder(aaa, bbb);
	if ( !ret ) { return 1; }
	
	
	LOG("+----------------------------------");
	LOG("| バッチ実行");
	LOG("+----------------------------------");
	ret = exec_batch(batch, args);
	if ( !ret ) { return 1; }
	
	
	LOG("+----------------------------------");
	LOG("| 実行結果をresultフォルダへコピー");
	LOG("+----------------------------------");
	ret = copy_folder(aaa, resultDir);
	if ( !ret ) { return 1; }
	
	ret = copy_folder(bbb, resultDir);
	if ( !ret ) { return 1; }
	
}


function cleanup_folder( folder )
{
	var ret = true;
	try {
		if ( folder.slice(-1) == "\\" ) folder = folder.slice(0, -1);
		if ( fso.FolderExists(folder) ) {
			LOG("[del] " + folder);
			var wshShell = new ActiveXObject("WScript.Shell");
			wshShell.Run("cmd.exe /c attrib -R -S -H /S /D \"" + folder + "\"", 1, true);
			WScript.Sleep(100);
			fso.DeleteFolder(folder, true);
		}
		LOG("[create] " + folder);
		fso.CreateFolder(folder);
	}
	catch ( e ) {
		LOG("[exception] cleanup_folder\n" + e.description)
		ret = false;
	}
	return ret;
}

function copy_folder( src, dst )
{
	var ret = true;
	try {
		LOG("[copy] " + src + " -> " + dst);
		fso.CopyFolder("src", "dst", true);
	}
	catch ( e ) {
		LOG("[exception] copy_folder\n" + e.description)
		ret = false;
	}
	return ret;
}

function exec_batch( batch, args )
{
	var ret = true;
	try {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "\"" + batch + "\" " + args;
		LOG("[exec] " + cmd);
		
		wshShell.Run(cmd, 1, true);
	}
	catch ( e )
	{
		LOG("[exception] exec_batch\n" + e.description)
		ret = false;
	}
	return ret;
}

function getDate() 
{
	var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
	var today = new Date();
	return (today.getYear() + f2d(today.getMonth() + 1) + f2d(today.getDate()) + "_"
			+ f2d(today.getHours()) + f2d(today.getMinutes()) + f2d(today.getSeconds()));
}

function LOG( str )
{
	WScript.Echo(str);
}
