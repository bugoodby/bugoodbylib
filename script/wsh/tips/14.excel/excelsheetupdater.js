//-----------------------------------------------------------
// DebugUtil v4
//-----------------------------------------------------------
var DebugUtil={c:true,f:false,ws:null,
	Init: function(target){this.c=true; this.f=false;
		if(target=="both"){this.f=true;} else if(target=="file"){this.c=false;this.f=true;}
		if(this.f){var fso=new ActiveXObject("Scripting.FileSystemObject");
		this.ws=fso.OpenTextFile(WScript.ScriptFullName.replace(WScript.ScriptName, "debuglog.txt"),8,true,0);
		this.ws.WriteLine("\n\n\n[[[LOG START: "+new Date()+" ]]]\n"); fso=null;}},
	Term: function(){if(this.f){this.ws.Close(); this.ws=null;}}
};
function LOG(str){
	if(DebugUtil.f){DebugUtil.ws.WriteLine(str);} if(DebugUtil.c){WScript.StdOut.WriteLine(str);}
}
function LOG_ARRAY(ary){
	var hr = "+-----------------------"; var c=0;
	LOG(hr); for(var i in ary){LOG("| "+i+" : "+ary[i]); c++;} LOG("| +len = "+c); LOG(hr); 
}
//-----------------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("引数が不正です");
		return 1;
	}
	
	// WScriptならCScriptで起動し直し
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function ExecScript( folder )
{
	DebugUtil.Init("both");
	
	var path = WScript.ScriptFullName.replace(WScript.ScriptName, "test_orgdata.xls");
	
	var updater = new ExcelDataUpdater();
	updater.init(path, "URL_List");
	updater.enumerate(folder);
	updater.exec();
	updater.term();
	
	DebugUtil.Term();
	return 0;
}

function ExcelDataUpdater()
{
	var m_oExcel = null;
	var m_fileList = [];
	
	var m_orgDataPath = "";
	var m_orgDataSheet = "";
	var m_oOrgBook = null;
	var m_oOrgSheet = null;
	
	this.init = function( path, sheetname )
	{
		m_orgDataPath = path;
		m_orgDataSheet = sheetname;
		
		// Excelオブジェクトの作成
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// ウィンドウ表示設定
		m_oExcel.DisplayAlerts = false;		// アラート設定
		
		// 元データファイルを読み取り専用で開く
		m_oOrgBook = m_oExcel.Workbooks.Open(m_orgDataPath, null, true);
		m_oOrgSheet = m_oOrgBook.WorkSheets(m_orgDataSheet);
		if ( !m_oOrgSheet ) {
			LOG("ERROR : シートがありません (" + m_orgDataSheet + ")");
			return false;
		}
		return true;
	};
	
	this.term = function()
	{
		m_oOrgBook.Close();
		m_oExcel.Quit();
		m_oExcel = null;
	};
	
	this.enumerate = function( folder )
	{
		var filter = "\.xls$";
		
		var enumerate_sub = function( folder ) {
			var d = fso.GetFolder(folder);
			var subdirs = new Enumerator(d.SubFolders);
			var files = new Enumerator(d.files);
			
			for ( ; !files.atEnd(); files.moveNext() ) {
				if ( files.item().Path.match(filter) ) {
					m_fileList.push(files.item().Path);
				}
			}
			for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
				enumerate_sub(subdirs.item().Path);
			}
		};
		
		LOG("Enumerate start: " + folder);
		m_fileList.length = 0;
		enumerate_sub(folder);
		LOG("Enumerate end: " + m_fileList.length);
	};
	
	this.exec = function()
	{
		for ( var i in m_fileList ) {
			copySheetData(m_fileList[i]);
		}
	};
	
	var copySheetData = function( f )
	{
		LOG("[update] " + f);
		
		var oBook = m_oExcel.Workbooks.Open(f);
		var oSheet = oBook.WorkSheets(m_orgDataSheet);
		if ( !oSheet ) {
			LOG("ERROR : シートがありません (" + m_orgDataSheet + ")");
			return false;
		}
		
		m_oOrgSheet.Cells.Copy();
		oSheet.Chells.PasteSpecial();
		
		oBook.Save();
		oBook.Close();
		return true;
	};
}

