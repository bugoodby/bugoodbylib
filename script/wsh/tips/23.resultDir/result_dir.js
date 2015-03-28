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
	//-----------------------------------------
	// 固定の結果フォルダ（毎回中身を空にする）
	{
		var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
		
		// resultフォルダ作成
		cleanup_folder(resultDir);
	}
	
	//-----------------------------------------
	// 可変の結果フォルダ（日付時刻のpostfixをつける）
	{
		var getDate = function() {
			var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
			var today = new Date();
			return (today.getYear() + f2d(today.getMonth() + 1) + f2d(today.getDate()) + "_"
					+ f2d(today.getHours()) + f2d(today.getMinutes()) + f2d(today.getSeconds()));
		}
		
		var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result_" + getDate() + "\\");
		
		// resultフォルダ作成
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

