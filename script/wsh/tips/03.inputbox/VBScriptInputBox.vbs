Dim str

str = InputBox("VBScript��InputBox���Ăяo���܂�", "InputBox", "123abc")
if str = vbNullString then
	WScript.Echo "�L�����Z������܂����B"
elseif Len(str) <> 0 then
	WScript.Echo str & vbCrLf & "����͂��܂����B"
else
	WScript.Echo "�������͂���܂���ł����B"
end if

