var wshShell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	var str = "";
	
	//---------------------------------------
	//�����ŗ^����ꂽ�p�X�̕���
	//---------------------------------------
	if ( argc > 0 ) {
		var path = argv(0);
		str = str + "[path]\n"
		str = str + path + "\n";
		
		str = str + "[FileSystemObject]\n"
		str = str + "GetAbsolutePathName(\".\")  : " + fso.GetAbsolutePathName(".") + "\n";
		str = str + "GetDriveName(arg)           : " + fso.GetDriveName(path) + "\n";
		str = str + "GetFileName(arg)            : " + fso.GetFileName(path) + "\n";
		str = str + "GetBaseName(arg)            : " + fso.GetBaseName(path) + "\n";
		str = str + "GetExtensionName(arg)       : " + fso.GetExtensionName(path) + "\n";
		str = str + "GetParentFolderName(arg)    : " + fso.GetParentFolderName(path) + "\n";
		str = str + "getDirPath(arg)             : " + getDirPath(path) + "\n";
		str = str + "changeExtension(arg, \"abc\") : " + changeExtension(path, "abc") + "\n";
		str = str + "\n";
		
		WScript.Echo(str);
		str = "";
	}
	
	//---------------------------------------
	//�J�����g�f�B���N�g��
	//---------------------------------------
	str = str + "[wshShell.CurrentDirectory]\n"
	str = str + wshShell.CurrentDirectory + "\n";
	str = str + "\n";
	
	str = str + "[fso.GetFolder(\".\").Path]\n"
	str = str + fso.GetFolder(".").Path + "\n";
	str = str + "\n";
	
	WScript.Echo(str);
	str = "";
	
	//---------------------------------------
	//����t�H���_
	//---------------------------------------
	str = str + "[wshShell.SpecialFolders]\n"
	str = str + "AllUsersDesktop    : " + wshShell.SpecialFolders("AllUsersDesktop") + "\n";
	str = str + "AllUsersStartMenu  : " + wshShell.SpecialFolders("AllUsersStartMenu") + "\n";
	str = str + "AllUsersPrograms   : " + wshShell.SpecialFolders("AllUsersPrograms") + "\n";
	str = str + "AllUsersStartup    : " + wshShell.SpecialFolders("AllUsersStartup") + "\n";
	str = str + "Desktop            : " + wshShell.SpecialFolders("Desktop") + "\n";
	str = str + "Favorites          : " + wshShell.SpecialFolders("Favorites") + "\n";
	str = str + "Fonts              : " + wshShell.SpecialFolders("Fonts") + "\n";
	str = str + "MyDocuments        : " + wshShell.SpecialFolders("MyDocuments") + "\n";
	str = str + "NetHood            : " + wshShell.SpecialFolders("NetHood") + "\n";
	str = str + "Programs           : " + wshShell.SpecialFolders("Programs") + "\n";
	str = str + "Recent             : " + wshShell.SpecialFolders("Recent") + "\n";
	str = str + "SendTo             : " + wshShell.SpecialFolders("SendTo") + "\n";
	str = str + "StartMenu          : " + wshShell.SpecialFolders("StartMenu") + "\n";
	str = str + "Startup            : " + wshShell.SpecialFolders("Startup") + "\n";
	str = str + "Templates          : " + wshShell.SpecialFolders("Templates") + "\n";
	str = str + "\n";

	str = str + "[fso.GetSpecialFolder]\n"
	str = str + "0    : " + fso.GetSpecialFolder(0) + "\n";
	str = str + "1    : " + fso.GetSpecialFolder(1) + "\n";
	str = str + "2    : " + fso.GetSpecialFolder(2) + "\n";
	str = str + "\n";
	
	WScript.Echo(str);
	str = "";
}


// �w�肵���t�@�C���̂���f�B���N�g����Ԃ�
// (�p�X�̖�����\�����Ă��邱�Ƃ�ۏ؁j
function getDirPath( path )
{
	var outdir = fso.GetParentFolderName(path);
	if ( outdir.slice(-1) != "\\" ) outdir += "\\";
	return outdir;
}

// �w�肵���t�@�C���̊g���q��ύX�����p�X��Ԃ�
function changeExtension( filespec, newExt )
{
	return fso.GetParentFolderName(filespec) + "\\" + fso.GetBaseName(filespec) + "." + newExt
}
