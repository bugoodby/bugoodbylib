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
	//-----------------------------------------
	// �Œ�̌��ʃt�H���_�i���񒆐g����ɂ���j
	{
		var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
		
		// result�t�H���_�쐬
		cleanup_folder(resultDir);
	}
	
	//-----------------------------------------
	// �ς̌��ʃt�H���_�i���t������postfix������j
	{
		var getDate = function() {
			var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
			var today = new Date();
			return (today.getYear() + f2d(today.getMonth() + 1) + f2d(today.getDate()) + "_"
					+ f2d(today.getHours()) + f2d(today.getMinutes()) + f2d(today.getSeconds()));
		}
		
		var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result_" + getDate() + "\\");
		
		// result�t�H���_�쐬
		LOG("[create] " + resultDir);
		fso.CreateFolder(resultDir);
	}
}

function cleanup_folder( folder )
{
	var ret = true;
	try {
		if ( folder.slice(-1) == "\\" ) folder = folder.slice(0, -1);
		if ( fso.FolderExists(folder) ) {
			LOG("[del] " + folder);
			fso.DeleteFolder(folder, true);
		}
		LOG("[create] " + folder);
		fso.CreateFolder(folder);
	}
	catch ( e ) {
		LOG("[exception] cleanup_folder: " + folder + "\n" + e.description)
		ret = false;
	}
	return ret;
}


function LOG( str )
{
	WScript.Echo(str);
}

