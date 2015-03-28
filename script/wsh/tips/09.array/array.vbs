Option Explicit

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
		cmd = cmd & " | more & pause"
		main = wshShell.Run(cmd, , True)
		Exit Function
	End If
	
	main = ExecScript()
End Function


Function ExecScript()
	dynamic_array
	static_array
End Function


Function dynamic_array()
	WScript.Echo "-----------------------"
	Dim count : count = 0
	Dim a : a = Array()
'	Dim a()		'この宣言方法ではLBound(),UBound()がエラーになる
	
	WScript.Echo "*before"
	show_array a
	
	ReDim Preserve a(count)
	a(count) = "carrot"
	count = count + 1
	
	ReDim Preserve a(count)
	a(count) = "green paper"
	count = count + 1
	
	WScript.Echo "*after"
	show_array a
End Function

Function static_array()
	WScript.Echo "-----------------------"
	Dim a : a = Array("apple", "orange", "grape")
	
	WScript.Echo "*static array"
	show_array a
End Function

Function show_array( a )
	Dim i
	WScript.Echo "length = " & UBound(a) - LBound(a) + 1
	For Each i in a
		WScript.Echo i
	Next
End Function
