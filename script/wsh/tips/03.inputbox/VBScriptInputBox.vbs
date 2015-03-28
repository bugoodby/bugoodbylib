Dim str

str = InputBox("VBScriptでInputBoxを呼び出します", "InputBox", "123abc")
if str = vbNullString then
	WScript.Echo "キャンセルされました。"
elseif Len(str) <> 0 then
	WScript.Echo str & vbCrLf & "を入力しました。"
else
	WScript.Echo "何も入力されませんでした。"
end if

