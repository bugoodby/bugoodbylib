var diffApp = "D:\\documents\\WinMergeU.exe"
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 2 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	
	if ( !fso.FileExists(diffApp) ) {
		WScript.Echo(diffApp + " が存在しません\n変数diffAppを正しく修正してください");
		return 1;
	}
	
	// 文字列リストを作成
	var aryL = ReadStringArray(argv(0));
	var aryR = ReadStringArray(argv(1));
	
	// 文字列リストをソート
	aryL.sort();
	aryR.sort();
	
	// ソート済みの文字列リストをテキスト出力
	var outfile1 = WScript.ScriptFullName.replace(WScript.ScriptName, "arrayL.txt");
	WriteStringArray(aryL, outfile1);
	var outfile2 = WScript.ScriptFullName.replace(WScript.ScriptName, "arrayR.txt");
	WriteStringArray(aryR, outfile2);
	
	// 比較ツールの起動
	var wshShell = new ActiveXObject("WScript.Shell");
	wshShell.Run(diffApp + " \"" + outfile1 + "\" \"" + outfile2 + "\"" , 1, false);
	
	return 0;
}

function ReadStringArray( file )
{
	var lines = [];
	
	if ( !fso.FileExists(file) ) {
		WScript.Echo("[ERROR] " + file + " が存在しません");
		return lines;
	}
	
	// テキストを読み込んで行ごとに配列化
	var rs = fso.OpenTextFile(file, 1, false, 0);
	var text = rs.ReadAll();
	rs.Close();
	lines = text.split("\r\n");
	
	// 文字列の前後の空白を除去
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
