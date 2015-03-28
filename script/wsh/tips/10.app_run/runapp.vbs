Option Explicit

Wscript.Quit main( WScript.Arguments.Count, WScript.Arguments )

Function main( argc, argv )
	' WScriptならCScriptで起動し直し
	If UCase(Right(WScript.FullName, 11)) = "WSCRIPT.EXE" Then
		Dim wshShell, cmd, i
		Set wshShell = CreateObject( "WScript.Shell" )
		cmd = "cmd /c cscript.exe //NOLOGO """ & WScript.ScriptFullName & """"
		For i = 0 To argc - 1
			cmd = cmd & " """ & argv(i) & """"
		Next
		cmd = cmd & " | more & pause"
		main = wshShell.Run(cmd, , True)
		Exit Function
	End If
	
	main = ExecScript()
End Function


Function ExecScript()
	runapp1
	runapp2
End Function

'-----------------------------------------------------
' object.Run(strCommand, [intWindowStyle], [bWaitOnReturn])
' 
'   strCommand     : 実行するコマンド ラインを示す文字列値
'   intWindowStyle : プログラムのウィンドウの外観
'   bWaitOnReturn  : true - プログラムが終了するまで待機しエラーコードを返す
'                    false - 即座に復帰して自動的に 0 を返す
'-----------------------------------------------------
Function runapp1()
	Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
	
	'メモ帳を起動
	wshShell.Run "C:\Windows\System32\notepad.exe", 1, vbFalse
	
	MsgBox "メモ帳を起動しました。"
End Function

'-----------------------------------------------------
' object.Exec(strCommand)
' 
'   strCommand : スクリプトの実行に使用するコマンド ラインを示す文字列値
'-----------------------------------------------------
Function runapp2()
	Dim oExec
	Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
	Dim cmd : cmd = "cmd.exe /c dir"
	
	'コマンド実行
	Set oExec = wshShell.Exec(cmd)
	Do While oExec.Status = 0
		WScript.Sleep 100
	Loop
	
	WScript.Echo "[StdOut]" & vbCrLf & oExec.StdOut.ReadAll()
	WScript.Echo "[StdErr]" & vbCrLf & oExec.StdErr.ReadAll()
End Function
