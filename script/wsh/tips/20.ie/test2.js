var fso = new ActiveXObject("Scripting.FileSystemObject");
var wshShell = new ActiveXObject("WScript.Shell");
var sh = new ActiveXObject("Shell.Application");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
	// WScript‚È‚çCScript‚Å‹N“®‚µ’¼‚µ
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	use_ie();
}

function use_ie()
{
	// IE‹N“®
	var ie = new ActiveXObject("InternetExplorer.Application");
	ie.Navigate("http://mirrors.axint.net/apache/");
	ie.Visible = true;
	
	while( ie.Busy || ie.ReadyState != 4/*READYSTATE_COMPLET*/ ) {
		WScript.Sleep( 100 );
	}
	
	var objIE = sh.Windows().Item(sh.Windows().Count - 1);
	
	LOG("yInnerHtmlz");
	str = objIE.document.body.InnerHtml;
	LOG(str);

	LOG("yInnerTextz");
	LOG(objIE.document.body.InnerText);
	LOG(ie.document.URL);
	LOG(ie.document.textContent);
	
	
	
//	ie.Quit();
	ie = null;
}


function LOG( str )
{
	WScript.Echo(str);
}
