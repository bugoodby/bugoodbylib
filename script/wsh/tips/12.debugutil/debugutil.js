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
function LOG_OBJECT(obj){
	var type = "???";
	if ( typeof(obj) == "object" ) {
		if ( obj == null ) { type = "Null"; }
		else { if ( (""+obj.constructor).match(/^\s*function +(\w+)/) ) { type = RegExp.$1; } }
	} else { type = typeof(obj); }
	LOG("| object type = " + type);
}
//-----------------------------------------------------------
WScript.Quit(main(WScript.Arguments.Count(), WScript.Arguments));

function main( argc, argv ) 
{
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
	
	return ExecScript();
}

function ExecScript()
{
	DebugUtil.Init("both");
	func("both");
	DebugUtil.Term();
	
	DebugUtil.Init("file");
	func("file");
	DebugUtil.Term();
	
	DebugUtil.Init();
	func("con");
	DebugUtil.Term();
	
	return 0;
}

function func(str)
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	
	var vUndef;
	var vNull = null;
	var vBool = true;
	var vNum = 100;
	var vStr = "文字列リテラル";
	var vString = new String("文字列オブジェクト");
	var ary1 = ["a1", "a2", "a3"];
	var ary2 = [100];
	var ary3 = {};
	
	LOG("\n\n*** type = " + str + " ***");
	
	LOG_OBJECT(vUndef);
	LOG_OBJECT(vNull);
	LOG_OBJECT(vBool);
	LOG_OBJECT(vNum);
	LOG_OBJECT(vStr);
	LOG_OBJECT(vString);
	LOG_OBJECT(ary1);
	LOG_OBJECT(ary3);
	LOG_OBJECT(fso);
	
	LOG_ARRAY(ary1);
	LOG_ARRAY(ary2);
	LOG_ARRAY(ary3);
}
