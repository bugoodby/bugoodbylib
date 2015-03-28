Dim wshShell : Set wshShell = CreateObject("WScript.Shell")
Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")

Call main( WScript.Arguments.Count, WScript.Arguments )

Function main( argc, argv )
	Dim str : str = ""
	
	'---------------------------------------
	'引数で与えられたパスの分解
	'---------------------------------------
	If argc > 0 Then
		Dim path : path = argv(0)
		str = str & "[path]" & vbCrLf
		str = str & path & vbCrLf
		
		str = str & "[FileSystemObject]" & vbCrLf
		str = str & "GetAbsolutePathName(""."")  : " & fso.GetAbsolutePathName(".") & vbCrLf
		str = str & "GetDriveName(arg)           : " & fso.GetDriveName(path) & vbCrLf
		str = str & "GetFileName(arg)            : " & fso.GetFileName(path) & vbCrLf
		str = str & "GetBaseName(arg)            : " & fso.GetBaseName(path) & vbCrLf
		str = str & "GetExtensionName(arg)       : " & fso.GetExtensionName(path) & vbCrLf
		str = str & "GetParentFolderName(arg)    : " & fso.GetParentFolderName(path) & vbCrLf
		str = str & "getDirPath(arg)             : " & getDirPath(path) & vbCrLf
		str = str & "changeExtension(arg, ""abc"") : " & changeExtension(path, "abc") & vbCrLf
		str = str & vbCrLf
		
		WScript.Echo str
		str = ""
	End If
	
	'---------------------------------------
	'カレントディレクトリ
	'---------------------------------------
	str = str & "[wshShell.CurrentDirectory]" & vbCrLf
	str = str & wshShell.CurrentDirectory & vbCrLf
	str = str & vbCrLf
	
	str = str & "[fso.GetFolder(""."").Path]" & vbCrLf
	str = str & fso.GetFolder(".").Path & vbCrLf
	str = str & vbCrLf
	
	WScript.Echo str
	str = ""
	
	'---------------------------------------
	'特殊フォルダ
	'---------------------------------------
	str = str & "[wshShell.SpecialFolders]" & vbCrLf
	str = str & "AllUsersDesktop    : " & wshShell.SpecialFolders("AllUsersDesktop") & vbCrLf
	str = str & "AllUsersStartMenu  : " & wshShell.SpecialFolders("AllUsersStartMenu") & vbCrLf
	str = str & "AllUsersPrograms   : " & wshShell.SpecialFolders("AllUsersPrograms") & vbCrLf
	str = str & "AllUsersStartup    : " & wshShell.SpecialFolders("AllUsersStartup") & vbCrLf
	str = str & "Desktop            : " & wshShell.SpecialFolders("Desktop") & vbCrLf
	str = str & "Favorites          : " & wshShell.SpecialFolders("Favorites") & vbCrLf
	str = str & "Fonts              : " & wshShell.SpecialFolders("Fonts") & vbCrLf
	str = str & "MyDocuments        : " & wshShell.SpecialFolders("MyDocuments") & vbCrLf
	str = str & "NetHood            : " & wshShell.SpecialFolders("NetHood") & vbCrLf
	str = str & "Programs           : " & wshShell.SpecialFolders("Programs") & vbCrLf
	str = str & "Recent             : " & wshShell.SpecialFolders("Recent") & vbCrLf
	str = str & "SendTo             : " & wshShell.SpecialFolders("SendTo") & vbCrLf
	str = str & "StartMenu          : " & wshShell.SpecialFolders("StartMenu") & vbCrLf
	str = str & "Startup            : " & wshShell.SpecialFolders("Startup") & vbCrLf
	str = str & "Templates          : " & wshShell.SpecialFolders("Templates") & vbCrLf
	str = str & vbCrLf

	str = str & "[fso.GetSpecialFolder]" & vbCrLf
	str = str & "0    : " & fso.GetSpecialFolder(0) & vbCrLf
	str = str & "1    : " & fso.GetSpecialFolder(1) & vbCrLf
	str = str & "2    : " & fso.GetSpecialFolder(2) & vbCrLf
	str = str & vbCrLf
	
	WScript.Echo str
	str = ""
End Function


' 指定したファイルのあるディレクトリを返す
' (パスの末尾に\がついていることを保証）
Function getDirPath( path )
	Dim outdir : outdir = fso.GetParentFolderName(path)
	If Right(outdir, 1) <> "\" Then outdir = outdir & "\" End If
	getDirPath = outdir
End Function


' 指定したファイルの拡張子を変更したパスを返す
Function changeExtension( filespec, newExt )
	changeExtension = fso.GetParentFolderName(filespec) & "\" & fso.GetBaseName(filespec) & "." & newExt
End Function
