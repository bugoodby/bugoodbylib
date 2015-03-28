'--------------------------------------------------------------
' getpath.vbs
'   D&DされたファイルのパスをInputBoxで表示する
'--------------------------------------------------------------
Option Explicit
Dim path : path = WScript.Arguments(0)
InputBox "length= " & Len(path), "getpath", path
