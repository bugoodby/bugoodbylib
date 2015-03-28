Option Explicit

Call main( WScript.Arguments.Count, WScript.Arguments )

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
	Dim user : user = ""
	Dim pass : pass = ""
	
	WScript.StdOut.WriteLine "USER: "
	user = WScript.StdIn.ReadLine()
	WScript.StdOut.WriteLine "PASS: "
	pass = WScript.StdIn.ReadLine()
	
	WScript.Echo "user=" & user & vbCrLf & "pass=" & pass
End Function

