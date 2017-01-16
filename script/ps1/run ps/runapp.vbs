Option Explicit

Dim wshShell : Set wshShell = WScript.CreateObject("WScript.Shell")
Dim script : script = Replace(WScript.ScriptFullName, WScript.ScriptName, "sub.ps1")
Dim cmd : cmd = "powershell -ExecutionPolicy RemoteSigned -File """ & script & """"
Dim exitcode : exitcode = wshShell.Run(cmd, 1, vbTrue)
'MsgBox "ExitCode: " & exitcode

WScript.Quit exitcode

