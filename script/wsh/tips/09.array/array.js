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
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	dynamic_array();
	static_array();
}


function dynamic_array()
{
	WScript.Echo("-----------------------");
	var a = [];
	
	WScript.Echo("*before");
	show_array(a);
	
	a.push("carrot");
	a.push("green paper");
	
	WScript.Echo("*after");
	show_array(a);
}

function static_array()
{
	WScript.Echo("-----------------------");
	var a = ["apple", "orange", "grape"];
	
	WScript.Echo("*static array");
	show_array(a);
}

function show_array( a )
{
	WScript.Echo("length = " + a.length);
	for ( var i in a ) {
		WScript.Echo(a[i]);
	}
}
