var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");

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
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}


function ExecScript(filespec)
{
	// �X�N���v�g�Ɠ����t�H���_���̃t�@�C��
	var file_in_scriptdir = WScript.ScriptFullName.replace(WScript.ScriptName, "hoge.txt");
	LOG( "file_in_scriptdir: " + file_in_scriptdir );
	
	// �����w��t�@�C���Ɠ����t�H���_���̃t�@�C��
	var file_in_argdir = fso.GetParentFolderName(filespec) + "\\hoge.txt";
	LOG( "file_in_argdir: " + file_in_argdir );
	
	
	var ret = test();
	LOG_ARRAY(ret);
}


function test()
{
	return { aaa:"hogehoge", bbb:3 };
}

function LOG( str ) {
	WScript.Echo(str);
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}

