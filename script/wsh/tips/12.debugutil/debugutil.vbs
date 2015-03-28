Option Explicit
'-----------------------------------------------------------
' DebugUtil v4
'-----------------------------------------------------------
Dim DebugUtil_c, DebugUtil_f, DebugUtil_ws
Function DebugUtil_Init(target)
	Select Case target
	Case "both" : DebugUtil_c = True : DebugUtil_f = True
	Case "file" : DebugUtil_c = False : DebugUtil_f = True
	Case Else : DebugUtil_c = True : DebugUtil_f = False
	End Select
	If DebugUtil_f Then
		Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
		Set DebugUtil_ws = fso.OpenTextFile(Replace(WScript.ScriptFullName, WScript.ScriptName, "debuglog.txt"), 8, True, 0)
		DebugUtil_ws.WriteLine vbCrLf & vbCrLf & vbCrLf & "[[[LOG START: " & Now & " ]]]" & vbCrLf
	End If
End Function
Function DebugUtil_Term()
	If DebugUtil_f Then DebugUtil_ws.Close() End If
End Function
Function LOG( str )
	If DebugUtil_f Then DebugUtil_ws.WriteLine str End If
	If DebugUtil_c Then WScript.StdOut.WriteLine str End If
End Function
Function LOG_ARRAY( ary )
	Dim i, c : c = 0
	LOG "+-----------------------"
	For i = LBound(ary) To UBound(ary) - LBound(ary)
		LOG "| " & i & " : " & ary(i) : c = c + 1
	Next
	LOG "| +len = " & c
	LOG "+-----------------------"
End Function
'-----------------------------------------------------------

Wscript.Quit main( WScript.Arguments.Count, WScript.Arguments )

Function main( argc, argv )
	' WScript‚È‚çCScript‚Å‹N“®‚µ’¼‚µ
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
	DebugUtil_Init "both"
	func "both"
	DebugUtil_Term
	
	DebugUtil_Init "file"
	func "file"
	DebugUtil_Term
	
	DebugUtil_Init "con"
	func "con"
	DebugUtil_Term
	
	ExecScript = 0
End Function


Function func(str)
	Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
	
	Dim ary1 : ary1 = Array("aaa", "bbb", "ccc")
	Dim ary2 : ary2 = Array(100)
	Dim ary3 : ary3 = Array()
	
	LOG vbCrLf & vbCrLf & "*** type = " & str & " ***"
	LOG_ARRAY ary1
	LOG_ARRAY ary2
	LOG_ARRAY ary3
End Function
