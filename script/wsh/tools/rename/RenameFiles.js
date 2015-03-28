
//------------------------------------------------
// ���[�U�[�ݒ�l
//------------------------------------------------

var g_remSrc = "1p";
var g_remDst = "5p";

var g_prefix = "";


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
var usage = "<About>\n" +
            "  �w�肳�ꂽ�t�H���_���̃t�@�C���̃��l�[�����s��\n" +
            "  ���݂̃��l�[�������� " + g_remSrc + " --> " + g_remDst + "\n" +
            "<Syntax>\n" +
            "  RenameFiles.js <dir>\n" +
            "    <dir> : �Ώۃt�H���_";

//------------------------------------------------
WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo(usage);
		return -1;
	}
	
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
	
	return RenameFiles( argv(0) );
}

function RenameFiles( folderspec )
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	
	//�t�H���_�̑��݃`�F�b�N
	if ( !fso.FolderExists(folderspec) ) {
		WScript.Echo("[ERROR] not found " + folderspec);
		return -1;
	}
	
	// ���O�t�@�C�����쐬
	var outfile = WScript.ScriptFullName.replace(WScript.ScriptName, 
		"renameLog_" + getDateString() + ".txt");
	var ws = fso.OpenTextFile( outfile, ForWriting, true, TristateUseDefault );
	ws.WriteLine("renamed files are as follows:\n\n");
	
	WScript.Echo("Renaming files...\n");
	RenameFilesSub(ws, folderspec);
	
	ws.Close();
	return 0;
}

function RenameFilesSub( ws, folderspec )
{
	var f, newName;
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var d = fso.GetFolder(folderspec);
	var files = new Enumerator(d.files);
	
	for ( ; !files.atEnd(); files.moveNext() ) {
		f = files.item();
		newName = f.Name;
		newName = g_prefix + newName.replace(g_remSrc, g_remDst);
		if ( newName != f.Name ) {
			WScript.Echo(f.Name + " --> " + newName);
			ws.WriteLine(f.Name + " --> " + newName);
			f.Name = newName;
		} else {
			WScript.Echo("   skip " + f.Name);
		}
	}

	return;
}

function getDateString() 
{
	var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
	var today = new Date();
	return (today.getYear() + f2d(today.getMonth() + 1) + f2d(today.getDate()) + "_"
			+ f2d(today.getHours()) + f2d(today.getMinutes()) + f2d(today.getSeconds()));
}
