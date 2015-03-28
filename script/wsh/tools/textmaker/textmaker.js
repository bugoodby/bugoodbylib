var fso = new ActiveXObject("Scripting.FileSystemObject");

WScript.Quit(main(WScript.Arguments.Count(), WScript.Arguments));

function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
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

function ExecScript( inifile )
{
	var GetLines = function( filespec, newline )
	{
		var lines = null;
		if ( fso.FileExists(filespec) ) {
			var rs = fso.OpenTextFile(filespec, 1, false, 0);
			var text = rs.ReadAll();
			rs.Close();
			lines = text.split(newline);
		} else {
			LOG("[ERROR] file not found : " + filespec);
		}
		return lines;
	};
	
	var ReadINI = function( filespec )
	{
		var ary = {}, line, sec = "";
		var lines = GetLines(filespec, "\r\n");
		for ( var i in lines ) {
			line = lines[i].replace(/^\s+|\s+$/g, "");
			if ( line.length == 0 || line.charAt(0) == ';' ) {
				continue;
			}
			if ( line.match(/^\[(.+)\]$/) ) {
				sec = RegExp.$1;
				ary[sec] = {};
			}
			var delimiter = line.search("=");
			if ( delimiter != -1 ) {
				var key = line.slice(0, delimiter).replace(/^\s+|\s+$/g, "");
				var val = line.slice(delimiter + 1).replace(/^\s+|\s+$/g, "");
				if ( sec != "" ) {
					ary[sec][key] = val;
				}
			}
		}
		return ary;
	};
	
	var createFiles = function( ini, templatefile, resultDir, tag )
	{
		var lines = GetLines(templatefile, "\r\n");
		
		if ( ini[tag] ) {
			for ( var i in ini[tag] ) {
				var outfile = resultDir + i + ".txt";
				var ws = fso.OpenTextFile(outfile, 2/*ForWriting*/, true, 0);
				for ( var j in lines ) {
					if ( lines[j].indexOf("INSERT_HERE") != -1 ) {
						ws.WriteLine(ini[tag][i]);
					} else {
						ws.WriteLine(lines[j]);
					}
				}
				ws.close();
			}
		}
	};
	
	// resultフォルダ作成
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
	if ( !fso.FolderExists(resultDir) ) {
		fso.CreateFolder(resultDir);
		LOG("created " + resultDir);
	}
	
	var ini = ReadINI(inifile);

	var templatefile = WScript.ScriptFullName.replace(WScript.ScriptName, "template.txt");
	createFiles(ini, templatefile, resultDir, "posconfig");

	var templatefile = WScript.ScriptFullName.replace(WScript.ScriptName, "template.txt");
	createFiles(ini, templatefile, resultDir, "typeconfig");
	
}

function LOG( str )
{
	WScript.Echo(str);
}
