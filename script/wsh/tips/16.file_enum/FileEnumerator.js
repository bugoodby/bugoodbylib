var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("[ERROR] �������s���ł�");
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
	
	return ExecScript(argv(0));
}

function ExecScript( folder )
{
	var fe = new FileEnumerator();
	
	fe.setFilter("\.(js|vbs)$")
	fe.enumerate(folder);
	fe.list();
	fe.exec(testFunc);
	
	return 0;
}

function testFunc( f )
{
	WScript.Echo("extension = " + fso.GetExtensionName(f));
	return true;
}

//------------------------------------------------
// FileEnumerator Class
//------------------------------------------------
function FileEnumerator( filter )
{
	var ft = filter || ".*";
	var fl = [];
	
	var enumerate_sub = function( folder )
	{
		var d = fso.GetFolder(folder);
		var subdirs = new Enumerator(d.SubFolders);
		var files = new Enumerator(d.files);
		
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( files.item().Path.match(ft) ) {
				fl.push(files.item().Path);
			}
		}
		for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
			enumerate_sub(subdirs.item().Path);
		}
	}
	
	// �t�@�C���񋓂̃t�B���^�[��ݒ肷��
	this.setFilter = function( filter )
	{
		ft = filter;
	}
	
	// �w��t�H���_���̃t�@�C����񋓂��A�������X�g�𐶐�
	this.enumerate = function( folder )
	{
		fl.length = 0;
		enumerate_sub(folder);
	}
	
	// �������X�g�̃t�@�C���ꗗ��\��
	this.list = function()
	{
		var s = "";
		for ( var i in fl ) {
			s += i + " : " + fl[i] + "\n";
		}
		WScript.Echo(s);
	}
	
	// �������X�g�̊e�t�@�C���ɑ΂���func�����s
	this.exec = function( callback )
	{
		for ( var i in fl ) {
			if ( callback(fl[i]) == false ) {
				return false;
			}
		}
		return true;
	}
}
