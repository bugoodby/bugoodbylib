Option Explicit

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
	WScript.Echo "CScript‚Å‹N“®‚µ‚Ü‚µ‚½"
	ExecScript = 0
End Function

