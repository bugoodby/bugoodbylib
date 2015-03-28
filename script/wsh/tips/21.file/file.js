var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	// WScript�Ȃ�CScript�ŋN��������
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
	
	// ������\\�ł����Ă��Ȃ��Ă��悢
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
	
	// *** subdir1�����̑S�t�@�C����subdir2�փR�s�[�i�T�u�t�H���_�̓R�s�[����Ȃ��j
	// *** subdir2�͑��݂��Ă���K�v������
	fso.CopyFile(root + "test1\\subdir1\\*", root + "test1\\subdir2", true);
	// src���t�@�C���w���dst���t�H���_�w��Ȃ�A����"\\"�K�v
	fso.CopyFile(root + "test1\\README.txt", root + "test1\\subdir2\\", true); 
	fso.CopyFile(root + "test1\\README.txt", root + "test1\\subdir2\\README_copy.txt", true);
	
	LOG("==============================================");
	LOG("xcopy");
	LOG("==============================================");
	
	// *** test1 ���̑S�t�@�C���� test2~test5 �փR�s�[�i�T�u�t�H���_���j
	// *** test2~test5 �͎����ō����
	// *** src�́A������\\�͂����Ă͂����Ȃ�
	// *** dst�̃t�H���_�����݂��Ȃ��Ƃ��A������\\�͂����Ă͂����Ȃ�
	// *** dst�t�H���_�͑��݂��Ă��Ă�OK
	fso.CopyFolder(root + "test1", root + "test2", true);
	fso.CopyFolder(root + "test1", root + "test3", true);
	fso.CopyFolder(root + "test1", root + "test4", true);
	fso.CopyFolder(root + "test1", root + "test4\\", true);
	fso.CopyFolder(root + "test1", root + "test5", true);
	
	LOG("==============================================");
	LOG("del");
	LOG("==============================================");
	
	// *** test4�����̃t�@�C�����폜
	fso.DeleteFile(root + "test4\\subdir1\\*", true);
	
	LOG("==============================================");
	LOG("rmdir");
	LOG("==============================================");
	
	// *** test5�t�H���_���폜
	// *** ������\\�͂����Ă͂����Ȃ�
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

