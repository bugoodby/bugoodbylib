'--------------------------------------------------------------
' getpath.vbs
'   D&D���ꂽ�t�@�C���̃p�X��InputBox�ŕ\������
'--------------------------------------------------------------
Option Explicit
Dim path : path = WScript.Arguments(0)
InputBox "length= " & Len(path), "getpath", path
