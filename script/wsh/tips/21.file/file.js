var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	// WScriptならCScriptで起動し直し
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
	var root = WScript.ScriptFullName.replace(WScript.ScriptName, "");
	
	LOG("==============================================");
	LOG("dir/file make");
	LOG("==============================================");
	
	// 末尾は\\であってもなくてもよい
	fso.CreateFolder(root + "test1");
	fso.CreateFolder(root + "test1\\subdir1");
	fso.CreateFolder(root + "test1\\subdir2\\");
	
	createTextFile(root + "test1\\README.txt", "here is root.");
	createTextFile(root + "test1\\subdir1\\file1.txt", "hogehoge");
	createTextFile(root + "test1\\subdir1\\file2_" + getDate1() + ".txt", "piyopiyo");
	createTextFile(root + "test1\\subdir1\\file3.txt", "fugafuga");
	
	fso.CreateFolder(root + "test1\\subdir1\\subdir1subdir");
	createTextFile(root + "test1\\subdir1\\subdir1subdir\\README.txt", "here is subdir of subdir1");
	
	LOG("==============================================");
	LOG("copy");
	LOG("==============================================");
	
	// *** subdir1直下の全ファイルをsubdir2へコピー（サブフォルダはコピーされない）
	// *** subdir2は存在している必要がある
	fso.CopyFile(root + "test1\\subdir1\\*", root + "test1\\subdir2", true);
	// srcがファイル指定でdstがフォルダ指定なら、末尾"\\"必要
	fso.CopyFile(root + "test1\\README.txt", root + "test1\\subdir2\\", true); 
	fso.CopyFile(root + "test1\\README.txt", root + "test1\\subdir2\\README_copy.txt", true);
	
	LOG("==============================================");
	LOG("xcopy");
	LOG("==============================================");
	
	// *** test1 下の全ファイルを test2~test5 へコピー（サブフォルダも）
	// *** test2~test5 は自動で作られる
	// *** srcは、末尾の\\はあってはいけない
	// *** dstのフォルダが存在しないとき、末尾の\\はあってはいけない
	// *** dstフォルダは存在していてもOK
	fso.CopyFolder(root + "test1", root + "test2", true);
	fso.CopyFolder(root + "test1", root + "test3", true);
	fso.CopyFolder(root + "test1", root + "test4", true);
	fso.CopyFolder(root + "test1", root + "test4\\", true);
	fso.CopyFolder(root + "test1", root + "test5", true);
	
	LOG("==============================================");
	LOG("del");
	LOG("==============================================");
	
	// *** test4直下のファイルを削除
	fso.DeleteFile(root + "test4\\subdir1\\*", true);
	
	LOG("==============================================");
	LOG("rmdir");
	LOG("==============================================");
	
	// *** test5フォルダを削除
	// *** 末尾の\\はあってはいけない
	fso.DeleteFolder(root + "test5", true);

}

function createTextFile( path, str )
{
	var ws = fso.OpenTextFile( path, 2/*ForWriting*/, true, 0 );
	ws.WriteLine(str);
	ws.Close();
}

function getDate1() 
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

