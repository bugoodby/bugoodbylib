Option Explicit

'------------------------------------------------
' FileSystemObject定数
'------------------------------------------------
' 入出力モード
Const ForReading   = 1
Const ForWriting   = 2
Const ForAppending = 8

' フォーマット
Const TristateUseDefault = -2	'システム既定
Const TristateTrue       = -1	'Unicode
Const TristateFalse      = 0	'ASCI

'------------------------------------------------
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")

Call main( WScript.Arguments.Count, WScript.Arguments )

Function main( argc, argv )
	' WScriptならCScriptで起動し直し
	If UCase(Right(WScript.FullName, 11)) = "WSCRIPT.EXE" Then
		Dim wshShell, cmd, i
		Set wshShell = CreateObject( "WScript.Shell" )   
		cmd = "cmd /c cscript.exe //NOLOGO """ & WScript.ScriptFullName & """"
		For i = 0 To argc - 1
			cmd = cmd & " """ & argv(i) & """"
		Next
		cmd = cmd & " & pause"
		main = wshShell.Run(cmd, , True)
		Exit Function
	End If
	
	main = ExecScript()
End Function


Function ExecScript()
	Dim filespec
	
	filespec = Replace(WScript.ScriptFullName, WScript.ScriptName, "test_inputfile.txt")
	ReadFile1 filespec
	ReadFile2 filespec
	
	filespec = Replace(WScript.ScriptFullName, WScript.ScriptName, "test_outputfile.txt")
	WriteFile1 filespec
End Function

'-----------------------------------------------
' ファイル読み込み（1行ずつ）
'-----------------------------------------------
Function ReadFile1( filespec )
	Dim line, rs
	
	WScript.StdOut.WriteLine "-------- ReadFile1 --------"
	
	'ファイルの存在チェック
	If fso.FileExists(filespec) = False Then
		WScript.Echo "[ERROR] file not found : " & filespec
		ExecScript = false
		Exit Function
	End If
	
	Set rs = fso.OpenTextFile(filespec, ForReading, False, TristateFalse)
	Do Until rs.AtEndOfStream = True
		line = rs.ReadLine
		WScript.StdOut.WriteLine line
	Loop
	rs.Close
	
	ReadFile1 = True
End Function

'-----------------------------------------------
' ファイル読み込み（一度に）
'-----------------------------------------------
Function ReadFile2( filespec )
	Dim rs, text, lines, l
	
	WScript.StdOut.WriteLine "-------- ReadFile2 --------"
	
	'ファイルの存在チェック
	If fso.FileExists(filespec) = False Then
		WScript.Echo "[ERROR] file not found : " & filespec
		ExecScript = false
		Exit Function
	End If
	
	Set rs = fso.OpenTextFile(filespec, ForReading, False, TristateFalse)
	text = rs.ReadAll
	rs.Close
	lines = Split(text, "\r\n")
	
	For Each l in lines
		WScript.StdOut.WriteLine l
	Next

	ReadFile2 = True
End Function


'-----------------------------------------------
' ファイル書き込み（1行ずつ）
'-----------------------------------------------
Function WriteFile1( filespec )
	Dim line, ws
	
	WScript.StdOut.WriteLine "-------- WriteFile1 --------"
	
	Set ws = fso.OpenTextFile(filespec, ForWriting, True, TristateFalse)
	WScript.StdOut.WriteLine "何か入力してください（改行後にCtrl+Cで終了)："
	Do While WScript.StdIn.AtEndOfStream = False
		line = WScript.StdIn.ReadLine
		ws.WriteLine line
	Loop
	ws.Close
	
	WriteFile1 = True
End Function
