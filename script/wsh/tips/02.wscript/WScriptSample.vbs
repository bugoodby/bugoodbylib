Dim str, i

' 引数の取得
str = str & "[Arguments]" & vbCrLf
str = str & "count : " & WScript.Arguments.Count & vbCrLf
For i = 0 To WScript.Arguments.Count - 1
	str = str & "arg(" & i & ") : " & WScript.Arguments(i) & vbCrLf
Next
str = str & vbCrLf

' 各種プロパティの取得
str = str & "[Data]" & vbCrLf
str = str & "Version        : " & WScript.Version & vbCrLf
str = str & "Name           : " & WScript.Name & vbCrLf
str = str & "Path           : " & WScript.Path & vbCrLf
str = str & "FullName       : " & WScript.FullName & vbCrLf
str = str & "Interactive    : " & WScript.Interactive & vbCrLf
str = str & "ScriptFullName : " & WScript.ScriptFullName & vbCrLf
str = str & "ScriptName     : " & WScript.ScriptName & vbCrLf
str = str & "ScriptPath     : " & Replace(WScript.ScriptFullName, WScript.ScriptName, "") & vbCrLf
str = str & vbCrLf

' ダイアログ ボックスまたはコンソールに出力
WScript.Echo str

' スクリプトのプロセスをミリ秒で指定された長さだけ非アクティブにした後、実行を再開
WScript.Sleep 100

' 実行の終了
WScript.Quit 0

