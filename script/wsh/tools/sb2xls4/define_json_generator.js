var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );
function main( argc, argv ) 
{
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
	// json�ɏo��
	var outfile = WScript.ScriptFullName.replace(WScript.ScriptName, "define.json");
	var ws = fso.OpenTextFile(outfile, 2/*ForWriting*/, true, 0/*ASCII*/);
	ws.WriteLine("(");
	ws.WriteLine("  {");
	
	
	try {
		// Excel�I�u�W�F�N�g�̍쐬
		var objExcel = new ActiveXObject("Excel.Application");
		objExcel.Visible = true;			// �E�B���h�E�\���ݒ�
		objExcel.DisplayAlerts = true;		// �A���[�g�ݒ�
		
		// Excel�t�@�C�����J��
		var infile = WScript.ScriptFullName.replace(WScript.ScriptName, "_define.xlsx");
		var objBook = objExcel.Workbooks.Open(infile);
		
		// �V�[�g�ꗗ�̎擾
		var sheet_names = [];
		var e = new Enumerator(objBook.WorkSheets);
		for ( ; !e.atEnd(); e.moveNext() ) {
			var name = e.item().Name;
			if ( name.indexOf("Sheet") != -1 ) {
				sheet_names.push(name);
			}
		}
		
		for ( var i = 0; i < sheet_names.length; i++ ) {
			LOG(sheet_names[i]);
			var oSheet = objBook.WorkSheets(sheet_names[i]);
		
			// �e�Z����������擾
			var GroupID = oSheet.Range("C3").Text;
			var Records = [];
			
			for ( var r = 7; ; r++ ) {
				var TrackID     = oSheet.Cells(r, 1).Text;
				var SSID        = oSheet.Cells(r, 2).Text;
				var Title       = oSheet.Cells(r, 11).Text;
				var Index       = oSheet.Cells(r, 12).Text;
				
				if ( TrackID == "" ) {
					break;
				}
				Records.push( {"TrackID": TrackID, "SSID": SSID, "Title": Title, "Index": Index} );
			}
			
			// json�ɏo��
//			if ( Records.length > 0 ) {
				ws.WriteLine("    \"" + GroupID + "\": {");
				for ( var j = 0; j < Records.length; j++ ) {
					ws.WriteLine("      \"" + Records[j].Index + "\": {");
					ws.WriteLine("        TrackID: \"" + Records[j].TrackID + "\", ");
					ws.WriteLine("        SSID: \"" + Records[j].SSID + "\", ");
					ws.WriteLine("        Title: \"" + Records[j].Title + "\" ");
					if ( j == Records.length - 1 ) ws.WriteLine("      }");
					else                           ws.WriteLine("      },");
				}
				if ( i == sheet_names.length - 1 ) ws.WriteLine("    }");
				else                               ws.WriteLine("    },");
//			}
		}
		
		// Excel�t�@�C�������
		objBook.Close();
		
		// Excel�I�u�W�F�N�g�̔j��
		objExcel.Quit();
		objExcel = null;
	}
	catch (e) {
		LOG("[ERROR] " + e.description);
		return false;
	}
	
	// json�ɏo��
	ws.WriteLine("  }");
	ws.WriteLine(");");
	ws.Close();
	
	return true;
}





function LOG( str )
{
	WScript.Echo(str);
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
