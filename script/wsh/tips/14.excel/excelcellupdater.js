//-----------------------------------------------------------
// DebugUtil v4
//-----------------------------------------------------------
var DebugUtil={c:true,f:false,ws:null,
	Init: function(target){this.c=true; this.f=false;
		if(target=="both"){this.f=true;} else if(target=="file"){this.c=false;this.f=true;}
		if(this.f){var fso=new ActiveXObject("Scripting.FileSystemObject");
		this.ws=fso.OpenTextFile(WScript.ScriptFullName.replace(WScript.ScriptName, "debuglog.txt"),8,true,0);
		this.ws.WriteLine("\n\n\n[[[LOG START: "+new Date()+" ]]]\n"); fso=null;}},
	Term: function(){if(this.f){this.ws.Close(); this.ws=null;}}
};
function LOG(str){
	if(DebugUtil.f){DebugUtil.ws.WriteLine(str);} if(DebugUtil.c){WScript.StdOut.WriteLine(str);}
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
//-----------------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("�������s���ł�");
		return 1;
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
	
	return ExecScript(argv(0));
}

function ExecScript( folder )
{
	DebugUtil.Init("both");
	
	var fe = new FileEnumerator();
	
	fe.setFilter("\.xls$")
	fe.enumerate(folder);
	fe.exec(changeCellValue);
	
	DebugUtil.Term();
	return 0;
}

function changeCellValue( f )
{
	var sheet_name = "URL_List";
	var target_row = 1;
	var target_col = 2;
	var val_after = "�ύX��̒l";
	
	LOG("[update] " + f);
	
	// Excel�I�u�W�F�N�g�̍쐬
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
	objExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
	
	// Excel�t�@�C�����J��
	var objBook = objExcel.Workbooks.Open(f);
	
	// �ΏۃV�[�g���擾
	var objTargetSheet = objBook.WorkSheets(sheet_name);
	if ( !objTargetSheet ) {
		LOG("ERROR : �V�[�g������܂��� (" + keyword + ")");
		return true;
	}
	
	// �l�̕ύX
	LOG(objTargetSheet.Cells(target_row, target_col).Value + " => " + val_after);
	objTargetSheet.Cells(target_row, target_col).Value = val_after;
	
	// �ۑ�
	objBook.Save();
	
	// �N���[�Y
	objBook.Close();
	
	objExcel.Quit();
	objExcel = null;
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
