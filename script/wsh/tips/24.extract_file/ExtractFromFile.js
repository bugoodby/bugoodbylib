var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");

WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));

function main( argc, argv ) 
{
	if ( argc < 1 ) {
		WScript.Echo("�t�@�C�����P�s���ǂ݁A���K�\���Ɉ�v������ʃt�@�C���ɏo�͂��܂�\n�t�@�C�����w�肵�Ă�������");
		return 1;
	}
	// WScript�Ȃ�CScript�ŋN��������
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		//var wshShell = new ActiveXObject("WScript.Shell");
		var strCmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			strCmd += " \"" + argv(i) + "\"";
		}
		strCmd += " | more & pause"
		return wshShell.Run(strCmd, 1, true);
	}
	
	ExtractFromFile(argv(0));
	
	return 0;
}

// �t�@�C�����P�s���ǂ݁A���K�\���Ɉ�v������ʃt�@�C���ɏo��
function ExtractFromFile( filespec )
{
	var out_file = WScript.ScriptFullName.replace(WScript.ScriptName, "ExtractFromFile.txt");
	var ws = fso.OpenTextFile(out_file, 2/*ForWriting*/, true, 0);
	
	var rs = fso.OpenTextFile(filespec, 1/*ForReading*/, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split(/\r\n/);
	
	for ( var i in lines ) {
		if ( lines[i].match(/^#define\s+([a-zA-Z0-9_]+)\s+([0-9]+).*/) ) {
			WScript.Echo(lines[i]);
			ws.WriteLine(RegExp.$2 + "," + RegExp.$1);
		}
	}
	
	ws.Close();
}
