function LOG( str )
{
	WScript.Echo(str);
}

WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	var url = "http://www.yahoo.co.jp/";
	
	// WScript‚È‚çCScript‚Å‹N“®‚µ’¼‚µ
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return HttpGetFile(url, ".");
}

function HttpGetFile( url, dst )
{
	var objHTTP = new ActiveXObject("MSXML2.XMLHTTP");

	var urlArray = url.split("/");
	var filename = urlArray[urlArray.length - 1];
	if ( filename.length == 0 ) {
		filename = "index.htm";
	}
	
	LOG("HTTP GET : " + url + " ==> " + dst);
	
	try {
		objHTTP.Open("GET", url, false);
	}
	catch (e) {
		LOG("  objHTTP.Open()\n" + e.Description);
		LOG("  operation failed.");
		return false;
	}
	try {
		objHTTP.Send();
	}
	catch (e) {
		LOG("  objHTTP.Send()\n" + e.Description);
		LOG("  operation failed.");
		return false;
	}
	LOG("  status: " + objHTTP.statusText);
	if ( objHTTP.status != 200 ) {
		LOG("  status is not OK.");
		LOG("  operation failed.");
		return false;
	}

	var objStream = new ActiveXObject("ADODB.Stream");
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	objStream.Open();
	objStream.Type = 1;
	objStream.Write(objHTTP.responseBody);
	objStream.SaveToFile(fso.BuildPath(dst, filename), 2);
	objStream.Close();
	
	return true;
}
