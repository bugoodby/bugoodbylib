var diffApp = "D:\\documents\\WinMergeU.exe"
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 2 ) {
		WScript.Echo("�������s���ł�");
		return 1;
	}
	
	if ( !fso.FileExists(diffApp) ) {
		WScript.Echo(diffApp + " �����݂��܂���\n�ϐ�diffApp�𐳂����C�����Ă�������");
		return 1;
	}
	
	// �����񃊃X�g���쐬
	var aryL = ReadStringArray(argv(0));
	var aryR = ReadStringArray(argv(1));
	
	// �����񃊃X�g���\�[�g
	aryL.sort();
	aryR.sort();
	
	// �\�[�g�ς݂̕����񃊃X�g���e�L�X�g�o��
	var outfile1 = WScript.ScriptFullName.replace(WScript.ScriptName, "arrayL.txt");
	WriteStringArray(aryL, outfile1);
	var outfile2 = WScript.ScriptFullName.replace(WScript.ScriptName, "arrayR.txt");
	WriteStringArray(aryR, outfile2);
	
	// ��r�c�[���̋N��
	var wshShell = new ActiveXObject("WScript.Shell");
	wshShell.Run(diffApp + " \"" + outfile1 + "\" \"" + outfile2 + "\"" , 1, false);
	
	return 0;
}

function ReadStringArray( file )
{
	var lines = [];
	
	if ( !fso.FileExists(file) ) {
		WScript.Echo("[ERROR] " + file + " �����݂��܂���");
		return lines;
	}
	
	// �e�L�X�g��ǂݍ���ōs���Ƃɔz��
	var rs = fso.OpenTextFile(file, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	lines = text.split("\r\n");
	
	// ������̑O��̋󔒂�����
	for ( var i in lines ) {
		lines[i] = lines[i].replace(/^\s+|\s+$/g, "");
	}
	return lines;
}

function WriteStringArray( ary, file )
{
	var ws = fso.OpenTextFile(file, 2, true, 0);
	for ( var i in ary ) {
		ws.WriteLine(ary[i]);
	}
	ws.Close();
	
	return true;
}
