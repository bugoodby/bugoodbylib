var fso = new ActiveXObject("Scripting.FileSystemObject");

WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc == 0 ) {
		WScript.Echo("引数が不正です");
		return;
	}
	
	// WScriptならCScriptで起動し直し
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " | more & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript( argc, argv );
}

function ExecScript( argc, argv )
{
	var shift_num = 0;
	var count = 0;
	
	WScript.StdOut.WriteLine("シフト数を入力: ");
	str = WScript.StdIn.ReadLine();
	if ( str != null ) {
		shift_num = parseInt(str, 10);
	}
	
	if ( shift_num > 0 )
	{
		var names = [];
		var hash = {}
		for ( var i = 0; i < argc; i++ ) {
			n = fso.GetBaseName(argv(i))
			names.push( n );
			hash[n] = argv(i);
		}
		names.sort();
		
		if ( names[0].match(/[^\d]*(\d+)$/) ) {
			count = RegExp.$1.length;
			WScript.Echo("number : " + RegExp.$1 + " : " + count);
		}
		
		for ( var i = names.length - 1; i >= 0 ; --i ) {
			if ( names[i].match(/([^\d]*)(\d+)$/) ) {
				var num = parseInt(RegExp.$2, 10);
				var prefix = RegExp.$1;
				var new_num_str = (function(){
					var s = "" + (num + shift_num);
					var z = count - s.length;
					while ( z > 0 ) {
						s = "0" + s;
						z--;
					}
					return s;
				})();
				var d = fso.GetFolder(hash[names[i]]);
				WScript.Echo(d.Name + " -> " + prefix + new_num_str);
				d.Name = prefix + new_num_str;
			}
		}
	}
}
