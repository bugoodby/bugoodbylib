//------------------------------------------------
// FileSystemObject定数
//------------------------------------------------
// 入出力モード
var ForReading   = 1;
var ForWriting   = 2;
var ForAppending = 8;

// フォーマット
var TristateUseDefault = -2;	//システム既定
var TristateTrue       = -1;	//Unicode
var TristateFalse      = 0;		//ASCI

//------------------------------------------------
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
	var filespec;
	
	filespec = WScript.ScriptFullName.replace(WScript.ScriptName, "test_inputfile.txt");
	ReadFile1(filespec);
	ReadFile2(filespec);
	
	filespec = WScript.ScriptFullName.replace(WScript.ScriptName, "test_outputfile.txt");
	WriteFile1(filespec);
}

//-----------------------------------------------
// ファイル読み込み（1行ずつ）
//-----------------------------------------------
function ReadFile1( filespec )
{
	var line;
	
	WScript.StdOut.WriteLine("-------- ReadFile1 --------");
	
	//ファイルの存在チェック
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
// ファイル読み込み（一度に）
//-----------------------------------------------
function ReadFile2( filespec )
{
	WScript.StdOut.WriteLine("-------- ReadFile2 --------");
	
	//ファイルの存在チェック
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
// ファイル書き込み（1行ずつ）
//-----------------------------------------------
function WriteFile1( filespec )
{
	var line;
	
	WScript.StdOut.WriteLine("-------- WriteFile1 --------");
	
	var ws = fso.OpenTextFile(filespec, 2/*ForWriting*/, true, 0/*ASCII*/);
	WScript.StdOut.WriteLine("何か入力してください（改行後にCtrl+Cで終了)：");
	do {
		line = WScript.StdIn.ReadLine();
		ws.WriteLine(line);
	} while ( !WScript.StdIn.AtEndOfStream );
	ws.Close();
	
	return true;
}
