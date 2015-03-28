var str = "";

// 引数の取得
str += "[Arguments]\n";
str += "count : " + WScript.Arguments.Count() + "\n";
for ( var i = 0; i < WScript.Arguments.Count(); i++ ) {
	str += "arg(" + i + ") : " + WScript.Arguments(i) + "\n";
}
str += "\n";

// 各種プロパティの取得
str += "[Data]\n"
str += "Version        : " + WScript.Version + "\n";
str += "Name           : " + WScript.Name + "\n";
str += "Path           : " + WScript.Path + "\n";
str += "FullName       : " + WScript.FullName + "\n";
str += "Interactive    : " + WScript.Interactive + "\n";
str += "ScriptFullName : " + WScript.ScriptFullName + "\n";
str += "ScriptName     : " + WScript.ScriptName + "\n";
str += "ScriptPath     : " + WScript.ScriptFullName.replace(WScript.ScriptName, "") + "\n";
str += "\n";

// ダイアログ ボックスまたはコンソールに出力
WScript.Echo(str);

// スクリプトのプロセスをミリ秒で指定された長さだけ非アクティブにした後、実行を再開
WScript.Sleep(100);

// 実行の終了
WScript.Quit(0);

