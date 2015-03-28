Option Explicit
Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")

Wscript.Quit main( WScript.Arguments.Count, WScript.Arguments )
Function main( argc, argv )
	If argc <> 1 Then
		WScript.Echo "[ERROR] �������s���ł�"
		main = 1
		Exit Function
	End If
	
	' WScript�Ȃ�CScript�ŋN��������
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
	
	main = ExecScript(argv(0))
End Function


Function ExecScript( folder )
	Dim i, fe
	Set fe = New FileEnumerator
	
	fe.setFilter "\.(js|vbs)$"
	fe.enumerate folder
	fe.list
	For Each i In fe.fl
		testFunc(i)
	Next
	
	ExecScript = 0
End Function


Function testFunc( f )
	WScript.Echo("extension = " & fso.GetExtensionName(f))
	testFunc = True
End Function



Class FileEnumerator
	Private ft
	Public fl

	Public Sub Class_Initialize()
		Set ft = new RegExp
		ft.pattern = ".*"
	End Sub
	
	Private Sub enumerate_sub( folder )
		Dim i, f, d
		Dim dir: Set dir = fso.GetFolder(folder)
		
		For Each f In dir.Files
			If ft.Test(f) = True Then
				i = UBound(fl) + 1
				Redim Preserve fl(i)
				fl(i) = f
			End If
		Next
		
		For Each d In dir.SubFolders
			enumerate_sub d.Path
		Next
	End Sub

	' �t�@�C���񋓂̃t�B���^�[��ݒ肷��
	Public Sub setFilter( filter )
		ft.pattern = filter
	End Sub
	
	' �w��t�H���_���̃t�@�C����񋓂��A�������X�g�𐶐�
	Public Sub enumerate( folder )
		fl = Array()
		enumerate_sub folder
	End Sub
	
	' �������X�g�̃t�@�C���ꗗ��\��
	Public Sub list()
		Dim i, s: s = ""
		For i = LBound(fl) To UBound(fl)
			s = s & i & " : " & fl(i) & vbCrLf
		Next
		WScript.Echo(s)
	End Sub
End Class

