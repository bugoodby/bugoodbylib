Option Explicit

Wscript.Quit main( WScript.Arguments.Count, WScript.Arguments )

Function main( argc, argv )
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
	
	main = ExecScript()
End Function


Function ExecScript()
	runapp1
	runapp2
End Function

'-----------------------------------------------------
' object.Run(strCommand, [intWindowStyle], [bWaitOnReturn])
' 
'   strCommand     : ���s����R�}���h ���C��������������l
'   intWindowStyle : �v���O�����̃E�B���h�E�̊O��
'   bWaitOnReturn  : true - �v���O�������I������܂őҋ@���G���[�R�[�h��Ԃ�
'                    false - �����ɕ��A���Ď����I�� 0 ��Ԃ�
'-----------------------------------------------------
Function runapp1()
	Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
	
	'���������N��
	wshShell.Run "C:\Windows\System32\notepad.exe", 1, vbFalse
	
	MsgBox "���������N�����܂����B"
End Function

'-----------------------------------------------------
' object.Exec(strCommand)
' 
'   strCommand : �X�N���v�g�̎��s�Ɏg�p����R�}���h ���C��������������l
'-----------------------------------------------------
Function runapp2()
	Dim oExec
	Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
	Dim cmd : cmd = "cmd.exe /c dir"
	
	'�R�}���h���s
	Set oExec = wshShell.Exec(cmd)
	Do While oExec.Status = 0
		WScript.Sleep 100
	Loop
	
	WScript.Echo "[StdOut]" & vbCrLf & oExec.StdOut.ReadAll()
	WScript.Echo "[StdErr]" & vbCrLf & oExec.StdErr.ReadAll()
End Function
