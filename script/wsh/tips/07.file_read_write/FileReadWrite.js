//------------------------------------------------
// FileSystemObject�萔
//------------------------------------------------
// ���o�̓��[�h
var ForReading   = 1;
var ForWriting   = 2;
var ForAppending = 8;

// �t�H�[�}�b�g
var TristateUseDefault = -2;	//�V�X�e������
var TristateTrue       = -1;	//Unicode
var TristateFalse      = 0;		//ASCI

//------------------------------------------------
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
	var filespec;
	
	filespec = WScript.ScriptFullName.replace(WScript.ScriptName, "test_inputfile.txt");
	ReadFile1(filespec);
	ReadFile2(filespec);
	
	filespec = WScript.ScriptFullName.replace(WScript.ScriptName, "test_outputfile.txt");
	WriteFile1(filespec);
}

//-----------------------------------------------
// �t�@�C���ǂݍ��݁i1�s���j
//-----------------------------------------------
function ReadFile1( filespec )
{
	var line;
	
	WScript.StdOut.WriteLine("-------- ReadFile1 --------");
	
	//�t�@�C���̑��݃`�F�b�N
	if ( !fso.FileExists(filespec) ) {
		WScript.Echo("[ERROR] file not found : " + filespec);
		return false;
	}
	
	var rs = fso.OpenTextFile(filespec, 1/*ForReading*/, false, 0/*ASCII*/);
	do {
		line = rs.ReadLine();
		WScript.StdOut.WriteLine(line);
	} while ( !rs.AtEndOfStream );
	rs.Close();
	
	return true;
}

//-----------------------------------------------
// �t�@�C���ǂݍ��݁i��x�Ɂj
//-----------------------------------------------
function ReadFile2( filespec )
{
	WScript.StdOut.WriteLine("-------- ReadFile2 --------");
	
	//�t�@�C���̑��݃`�F�b�N
	if ( !fso.FileExists(filespec) ) {
		WScript.Echo("[ERROR] file not found : " + filespec);
		return false;
	}
	
	var rs = fso.OpenTextFile(filespec, 1/*ForReading*/, false, 0/*ASCII*/);
	var text = rs.ReadAll();
	rs.Close();
	var lines = text.split("\r\n");
	
	for ( var i in lines ) {
		WScript.StdOut.WriteLine(lines[i]);
	}
	
	return true;
}


//-----------------------------------------------
// �t�@�C���������݁i1�s���j
//-----------------------------------------------
function WriteFile1( filespec )
{
	var line;
	
	WScript.StdOut.WriteLine("-------- WriteFile1 --------");
	
	var ws = fso.OpenTextFile(filespec, 2/*ForWriting*/, true, 0/*ASCII*/);
	WScript.StdOut.WriteLine("�������͂��Ă��������i���s���Ctrl+C�ŏI��)�F");
	do {
		line = WScript.StdIn.ReadLine();
		ws.WriteLine(line);
	} while ( !WScript.StdIn.AtEndOfStream );
	ws.Close();
	
	return true;
}
