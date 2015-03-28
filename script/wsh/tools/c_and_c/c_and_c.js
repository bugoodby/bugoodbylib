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
var wshShell = new ActiveXObject("WScript.Shell");


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
	
	var tprm = new TestPlanResultManager(folder);
	tprm.findTestCaseResult();
	tprm.execCheck();
	
	DebugUtil.Term();
	return 0;
}

function TestPlanResultManager( path )
{
	this.path = path;
	var tcrmList = [];
	var resultDir = WScript.ScriptFullName.replace(WScript.ScriptName, "result\\");
	
	var initialize = function()
	{
		// resultフォルダ作成
		if ( fso.FolderExists(resultDir) ) {
			LOG("[del] " + resultDir + "\\*");
			fso.DeleteFile(resultDir + "\\*", true);
		} else {
			LOG("[create] " + resultDir);
			fso.CreateFolder(resultDir);
		}
	};
	
	this.findTestCaseResult = function()
	{
		LOG("*** TestPlanResultManager.findTestCaseResult() start ***");
		findTestCaseResult_sub(this.path);
		LOG("*** TestPlanResultManager.findTestCaseResult() end ***");
	}
	
	var findTestCaseResult_sub = function( folderspec )
	{
		var d = fso.GetFolder(folderspec);
		var subdirs = new Enumerator(d.SubFolders);
		var files = new Enumerator(d.files);
		
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( files.item().Name == "test.txt" ) {
				// found TestCaseResult
				var tcrPath = fso.GetParentFolderName(files.item().Path);
				var tcrm = new TestCaseResultManager(tcrPath);
				tcrmList.push(tcrm);
				break;
			}
		}
		for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
			findTestCaseResult_sub(subdirs.item().Path);
		}
	};
	
	this.execCheck = function()
	{
		LOG("*** TestPlanResultManager.execCheck() start ***");
		for ( var i in tcrmList ) {
			tcrmList[i].execCheck(resultDir);
		}
		LOG("*** TestPlanResultManager.execCheck() end ***");
	};

	initialize();
}

function TestCaseResultManager( path )
{
	this.path = path;
	this.id = fso.GetBaseName(path);
	this.logList = [];
	
	var initialize = function( folder )
	{
		var d = fso.GetFolder(folder);
		var files = new Enumerator(d.files);
		var re = new RegExp("^" + this.id + "\.txt");
		
		for ( ; !files.atEnd(); files.moveNext() ) {
			if ( re.test(files.item().Name) ) {
				LOG("match : " + files.item().Name);
				this.logList.push( files.item().Name );
			}
		}
		
		LOG(" - TestResultManager : " + this.id);
		LOG_ARRAY(this.logList);
	};
	
	var execCheck = function( resultDir )
	{
		// 結果フォルダ作成
		var tcResultDir = resultDir + this.id + "\\";
		if ( fso.FolderExists(tcResultDir) ) {
			LOG("[del] " + tcResultDir + "\\*");
			fso.DeleteFile(tcResultDir + "\\*", true);
		} else {
			LOG("[create] " + tcResultDir);
			fso.CreateFolder(tcResultDir);
		}
		
		if ( this.logList.length == 0 ) {
			LOG("[ERROR] log file not found");
			return ;
		}
		
		var src = this.path + "\\" + this.logList[0];
		var dst = this.path + "\\test.log";
		fso.CopyFile(src, dst, true);
		
		// do check
		
		// fso.CopyFile();
		
		fso.DeleteFile(dst, true);
	}
	
	initialize( path );
}

