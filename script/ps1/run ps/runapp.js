
var wshShell = new ActiveXObject("WScript.Shell");
var script = WScript.ScriptFullName.replace(WScript.ScriptName, "sub.ps1");
var cmd = "powershell -ExecutionPolicy RemoteSigned -File \"" + script + "\"";
var exitcode = wshShell.Run(cmd, 1, true);
wshShell.Popup("ExitCode: " + exitcode);

WScript.Quit(exitcode);
