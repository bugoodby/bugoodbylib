//--------------------------------------------------------------
// doxygenhelper.js
//   doxyfileを生成し設定を変更する
//--------------------------------------------------------------
var DOXY_PATH = "C:\\Program Files\\doxygen\\bin\\doxygen.exe"
var DOT_PATH = "C:\\Program Files (x86)\\Graphviz 2.34\\bin";


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("対象プロジェクトのディレクトリを指定してください");
		return 1;
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
	
	return ExecScript(argv(0));
}

function ExecScript( target )
{
	var wshShell = new ActiveXObject("WScript.Shell");
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var prjName = fso.GetBaseName(target);
	var configFile = WScript.ScriptFullName.replace(WScript.ScriptName, "doxyfile");

	//--------------------------------------------
	// create default doxyfile
	//--------------------------------------------
	var oExec = wshShell.Exec(DOXY_PATH + " -g " + configFile);
	while ( oExec.Status == 0 ) {
		WScript.Sleep(100);
	}
	WScript.Echo("[StdOut]\n" + oExec.StdOut.ReadAll());
	WScript.Echo("[StdErr]\n" + oExec.StdErr.ReadAll());
	
	WScript.Sleep(1000);
	
	//--------------------------------------------
	// modify doxyfile
	//--------------------------------------------
	var outfile = configFile + "_" + prjName;
	
	var rs = fso.OpenTextFile( configFile, 1/*ForReading*/, false, 0 );
	var ws = fso.OpenTextFile( outfile, 2/*ForWriting*/, true, 0 );
	
	do {
		line = rs.ReadLine();
		
		if ( line.match(/^(PROJECT_NAME\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " " + prjName);
		}
		else if ( line.match(/^(CREATE_SUBDIRS\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(OUTPUT_LANGUAGE\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " Japanese");
		}
		else if ( line.match(/^(TYPEDEF_HIDES_STRUCT\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(EXTRACT_ALL\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(INPUT\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " \"" + target + "\"");
		}
		else if ( line.match(/^(RECURSIVE\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(SOURCE_BROWSER\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(STRIP_CODE_COMMENTS\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " NO");
		}
		else if ( line.match(/^(HTML_OUTPUT\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " html_" + prjName);
		}
		else if ( line.match(/^(HTML_DYNAMIC_SECTIONS\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(GENERATE_LATEX\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " NO");
		}
		else if ( line.match(/^(HAVE_DOT\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(CALL_GRAPH\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(CALLER_GRAPH\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else if ( line.match(/^(DOT_PATH\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " \"" + DOT_PATH + "\"");
		}
		else if ( line.match(/^(DOT_GRAPH_MAX_NODES\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " 50");
		}
		else if ( line.match(/^(MAX_DOT_GRAPH_DEPTH\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " 5");
		}
		else if ( line.match(/^(DOT_MULTI_TARGETS\s*=)/) ) {
			ws.WriteLine(RegExp.$1 + " YES");
		}
		else {
			ws.WriteLine(line);
		}
	} while ( !rs.AtEndOfStream );
	
	rs.Close();
	ws.Close();
}

//
// set DOXYGEN=C:\Program Files\doxygen\bin\doxygen.exe
// "%DOXYGEN%" "%1"
// pause
//
