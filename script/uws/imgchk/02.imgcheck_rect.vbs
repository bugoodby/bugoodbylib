Dim uwsc : uwsc = "C:\mywork\UWSC\UWSC.exe"
Dim script : script = Replace(WScript.ScriptFullName, WScript.ScriptName, "02.imgcheck_rect.uws")

if WScript.Arguments.Count = 0 then
	WScript.Echo "usage: bmpファイルをドラッグ＆ドロップ"
	WScript.Quit
end if

Dim cmd : cmd = """" & uwsc & """ """ & script & """ """ & WScript.Arguments(0) & """"
'WScript.Echo "[exec] " & cmd

Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
wshShell.Run cmd, 1, vbTrue
