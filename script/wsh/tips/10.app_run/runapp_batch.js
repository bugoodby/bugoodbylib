
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
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	runapp1();
	runapp2();
}

//-----------------------------------------------------
// object.Run(strCommand, [intWindowStyle], [bWaitOnReturn])
// 
//   strCommand     : 実行するコマンド ラインを示す文字列値
//   intWindowStyle : プログラムのウィンドウの外観
//   bWaitOnReturn  : true - プログラムが終了するまで待機しエラーコードを返す
//                    false - 即座に復帰して自動的に 0 を返す
//-----------------------------------------------------
function runapp1()
{
	var wshShell = new ActiveXObject("WScript.Shell");
	var batch = WScript.ScriptFullName.replace(WScript.ScriptName, "05.call_sub.bat");
//	var cmd = "cmd.exe /c \"" + batch + "\"";
	var cmd = "\"" + batch + "\"";
	
	WScript.Echo("実行開始...");
	wshShell.Run(cmd, 1, true);
	WScript.Echo("実行終了");
}

//-----------------------------------------------------
// object.Exec(strCommand)
// 
//   strCommand : スクリプトの実行に使用するコマンド ラインを示す文字列値
//-----------------------------------------------------
function runapp2()
{
	var wshShell = new ActiveXObject("WScript.Shell");
	var batch = WScript.ScriptFullName.replace(WScript.ScriptName, "05.call_sub.bat");
//	var cmd = "cmd.exe /c \"" + batch + "\"";
	var cmd = "\"" + batch + "\"";
	
	WScript.Echo("実行開始...");
	var oExec = wshShell.Exec(cmd);
	while ( oExec.Status == 0 ) {
		WScript.Sleep(100);
	}
	WScript.Echo("実行終了");
	
	WScript.Echo("[StdOut]\n" + oExec.StdOut.ReadAll());
	WScript.Echo("[StdErr]\n" + oExec.StdErr.ReadAll());
}
