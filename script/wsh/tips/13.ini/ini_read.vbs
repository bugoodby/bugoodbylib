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
	DebugUtil_Init "both"
	
	read_ini "non_exist_file.ini"
	read_ini Replace(WScript.ScriptFullName, WScript.ScriptName, "test.ini")
	read_ini_sec Replace(WScript.ScriptFullName, WScript.ScriptName, "test.ini")
	
	DebugUtil_Term
End Function


' セクションを無視し、単純に key = val だけ抽出して配列に格納
Function read_ini( filespec )
	Dim ary : ary = Array()
	Dim rs, line, delimiter, cnt : cnt = 0
	
	LOG filespec
	Redim ary(2, 0)
	
	If fso.FileExists(filespec) = False Then
		LOG "[ERROR] file not found : " & filespec
	Else
		Set rs = fso.OpenTextFile(filespec, 1, False, 0)
		Do Until rs.AtEndOfStream = True
			line = TrimSpaceTab(rs.ReadLine)
			If Len(line) <> 0 And Left(line, 1) <> ";" Then
				delimiter = InStr(line, "=")
				If delimiter > 0 Then
					Redim Preserve ary(2, cnt)
					ary(1, cnt) = TrimSpaceTab(Left(line, delimiter - 1))
					ary(2, cnt) = TrimSpaceTab(Mid(line, delimiter + 1))
					cnt = cnt + 1
				End If
			End If
		Loop
		rs.Close
	End If
	
	Dim i, c : c = 0
	LOG "+-----------------------"
	For i = LBound(ary, 2) To UBound(ary, 2) - LBound(ary, 2)
		LOG "| " & ary(1, i) & " : " & ary(2, i) : c = c + 1
	Next
	LOG "| +len = " & c
	LOG "+-----------------------"
End Function
	
Function TrimSpaceTab( str )
	Dim re : Set re = New RegExp
	re.Pattern = "^\s+|\s+$"
	re.Multiline = False
	re.Global = True
	TrimSpaceTab = re.Replace(str, "")
End Function


' セクションを意識し、"section.key"の形式で配列の1番目に格納
Function read_ini_sec( filespec )
	Dim rs, line, delimiter, matches, key, sec, cnt : sec = "" : cnt = 0
	
	LOG filespec
	
	Dim ary : ary = Array()
	Redim ary(2, 0)
	Dim re : Set re = New RegExp
	re.Pattern = "^\[(.+)\]$"
	
	If fso.FileExists(filespec) = False Then
		LOG "[ERROR] file not found : " & filespec
	Else
		Set rs = fso.OpenTextFile(filespec, 1, False, 0)
		Do Until rs.AtEndOfStream = True
			line = TrimSpaceTab(rs.ReadLine)
			If Len(line) = 0 Or Left(line, 1) = ";" Then
				'NOP
			Else
				Set matches = re.Execute(line)
				If matches.Count <> 0 Then
					sec = matches(0).SubMatches(0)
				Else
					delimiter = InStr(line, "=")
					If delimiter > 0 Then
						Redim Preserve ary(2, cnt)
						key = TrimSpaceTab(Left(line, delimiter - 1))
						If sec <> "" Then
							ary(1, cnt) = sec & "." & key
						Else
							ary(1, cnt) = key
						End If
						ary(2, cnt) = TrimSpaceTab(Mid(line, delimiter + 1))
						cnt = cnt + 1
					End If
				End If
			End If
		Loop
		rs.Close
	End If
	
	Dim i, c : c = 0
	LOG "+-----------------------"
	For i = LBound(ary, 2) To UBound(ary, 2) - LBound(ary, 2)
		LOG "| " & ary(1, i) & " : " & ary(2, i) : c = c + 1
	Next
	LOG "| +len = " & c
	LOG "+-----------------------"
End Function


