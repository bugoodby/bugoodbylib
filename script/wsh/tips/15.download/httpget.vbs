Option Explicit

Function LOG( str )
	WScript.Echo str
End Function

Wscript.Quit main( WScript.Arguments.Count, WScript.Arguments )
Function main( argc, argv )
	Dim url : url = "http://www.yahoo.co.jp/"
	
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
	
	main = HttpGetFile(url, ".")
End Function


Function HttpGetFile( url, dst )
	Dim urlArray, filename
	Dim objHTTP : Set objHTTP = WScript.CreateObject("MSXML2.XMLHTTP")
	HttpGetFile = False
	
	urlArray = Split(url, "/")
	filename = urlArray(UBound(urlArray))
	If Len(filename) = 0 Then
		filename = "index.htm"
	End If
	
	LOG "HTTP GET : " & url & " ==> " & dst
	
	on error resume next
	objHTTP.Open "GET", url, False
	If Err.Number <> 0 then
		LOG "  objHTTP.Open()" & vbCrLf & Err.Description
		LOG "  operation failed."
		Exit Function
	End If
	objHTTP.Send
	If Err.Number <> 0 then
		LOG "  objHTTP.Send()" & vbCrLf & Err.Description
		LOG "  operation failed."
		Exit Function
	End If
	on error goto 0
	LOG "  status: " & objHTTP.statusText
	If objHTTP.status <> 200 Then
		LOG "  status is not OK."
		LOG "  operation failed."
		Exit Function
	End If

	Dim objStream : Set objStream = WScript.CreateObject("ADODB.Stream")
	Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
	objStream.Open
	objStream.Type = 1
	objStream.Write objHTTP.responseBody
	objStream.SaveToFile fso.BuildPath(dst, filename), 2
	objStream.Close
	
	HttpGetFile = True
End Function
