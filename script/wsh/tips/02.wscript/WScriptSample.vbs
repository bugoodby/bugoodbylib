Dim str, i

' �����̎擾
str = str & "[Arguments]" & vbCrLf
str = str & "count : " & WScript.Arguments.Count & vbCrLf
For i = 0 To WScript.Arguments.Count - 1
	str = str & "arg(" & i & ") : " & WScript.Arguments(i) & vbCrLf
Next
str = str & vbCrLf

' �e��v���p�e�B�̎擾
str = str & "[Data]" & vbCrLf
str = str & "Version        : " & WScript.Version & vbCrLf
str = str & "Name           : " & WScript.Name & vbCrLf
str = str & "Path           : " & WScript.Path & vbCrLf
str = str & "FullName       : " & WScript.FullName & vbCrLf
str = str & "Interactive    : " & WScript.Interactive & vbCrLf
str = str & "ScriptFullName : " & WScript.ScriptFullName & vbCrLf
str = str & "ScriptName     : " & WScript.ScriptName & vbCrLf
str = str & "ScriptPath     : " & Replace(WScript.ScriptFullName, WScript.ScriptName, "") & vbCrLf
str = str & vbCrLf

' �_�C�A���O �{�b�N�X�܂��̓R���\�[���ɏo��
WScript.Echo str

' �X�N���v�g�̃v���Z�X���~���b�Ŏw�肳�ꂽ����������A�N�e�B�u�ɂ�����A���s���ĊJ
WScript.Sleep 100

' ���s�̏I��
WScript.Quit 0

