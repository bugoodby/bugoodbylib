//--------------------------------------------------------------
// cleandir.js
//   �w�肵���t�H���_���ċA�������A����g���q�̃t�@�C�����폜����
//--------------------------------------------------------------

// �폜����g���q���w��
var rgExp = "\.(ncb|obj|ilk|map|pdb|idb|pch|aps|suo)$";

//--------------------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");

WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));

function main( argc, argv ) 
{
	var usage = 
	"�w�肳�ꂽ�g���q�̃t�@�C���폜���s��\n" +
	"�����݂̐ݒ�: " + rgExp + "\n\n" +
	WScript.ScriptName + " <dir>\n" +
	"  <dir> : �Ώۃt�H���_";
	
	if ( argc != 1 ) {
		WScript.Echo(usage);
		return 0;
	}
	
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
	
	return DeleteSpecifiedFiles( argv(0) );
}


function DeleteSpecifiedFiles( folderspec )
{
	//�t�H���_�̑��݃`�F�b�N
	if ( !fso.FolderExists(folderspec) ) {
		WScript.Echo("[ERROR] not found " + folderspec);
		return -1;
	}
	
	// ���O�t�@�C�����쐬
	var outfile = WScript.ScriptFullName.replace(WScript.ScriptName, 
		"deleteLog_" + getDateString() + ".txt");
	var ws = fso.OpenTextFile( outfile, 2/*ForWriting*/, true, 0 );
	ws.WriteLine("deleted files are as follows:\n\n");
	
	// �t�@�C���폜
	WScript.Echo("Deleting files...\n");
	DeleteSpecifiedFilesSub(ws, folderspec);
	
	ws.Close();
	return 0;
}

function DeleteSpecifiedFilesSub( ws, folderspec )
{
	var d = fso.GetFolder(folderspec);
	var subdirs = new Enumerator(d.SubFolders);
	var files = new Enumerator(d.files);
	
	for ( ; !files.atEnd(); files.moveNext() ) {
		if ( files.item().Path.match(rgExp) ) {
			ws.WriteLine(files.item().Path);
			fso.DeleteFile(files.item().Path, true);
		}
	}
	for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
		DeleteSpecifiedFilesSub(ws, subdirs.item().Path);
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

