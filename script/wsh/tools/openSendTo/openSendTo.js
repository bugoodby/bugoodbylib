//--------------------------------------------------------------
// openSendTo.js
//   エクスプローラでSendToフォルダを開く
//--------------------------------------------------------------
var wshShell = new ActiveXObject("WScript.Shell");
wshShell.Run(wshShell.SpecialFolders("SendTo"), 1, false);

