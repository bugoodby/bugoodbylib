//--------------------------------------------------------------
// openSendTo.js
//   �G�N�X�v���[����SendTo�t�H���_���J��
//--------------------------------------------------------------
var wshShell = new ActiveXObject("WScript.Shell");
wshShell.Run(wshShell.SpecialFolders("SendTo"), 1, false);

