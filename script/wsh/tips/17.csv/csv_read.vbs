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
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")


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
	
	read_csv Replace(WScript.ScriptFullName, WScript.ScriptName, "test1.csv")
	read_csv Replace(WScript.ScriptFullName, WScript.ScriptName, "test2.csv")
	
	DebugUtil_Term
End Function


Function read_csv( filespec )
	Dim ary : ary = Array()
	Dim items : items = Array()
	Dim rs, line, i, cnt : cnt = 0
	
	LOG filespec
	Redim ary(0)
	
	If fso.FileExists(filespec) = False Then
		LOG "[ERROR] file not found : " & filespec
	Else
		Set rs = fso.OpenTextFile(filespec, 1, False, 0)
		Do Until rs.AtEndOfStream = True
			line = TrimSpaceTab(rs.ReadLine)
			If Len(line) <> 0 Then
				items = Split(line,",")
				For i = LBound(items) To UBound(items) - LBound(items)
					items(i) = FormatItem(items(i))
				Next
				Redim Preserve ary(cnt)
				ary(cnt) = items
				cnt = cnt + 1
			End If
		Loop
		rs.Close
	End If
	
	For i = LBound(ary) To UBound(ary) - LBound(ary)
		LOG "[" & i & "]"
		LOG_ARRAY(ary(i))
	Next
End Function
	
Function TrimSpaceTab( str )
	Dim re : Set re = New RegExp
	re.Pattern = "^\s+|\s+$"
	re.Multiline = False
	re.Global = True
	TrimSpaceTab = re.Replace(str, "")
End Function

Function FormatItem( str )
	Dim s : s = Trim(str)
	If Len(s) > 1 And Left(s, 1) = """" And Right(s, 1) = """" Then
		s = Mid(s, 2)
		s = Left(s, Len(s) - 1)
	End If
	FormatItem = s
End Function

