
var d = new Date();

WScript.Echo("object:           " + d + "\r\n" +
			 "toString():       " + d.toString() + "\r\n" +
			 "toUTCString():    " + d.toUTCString() + "\r\n" +
			 "toLocaleString(): " + d.toLocaleString() + "\r\n"
			);

var tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate()+1);
WScript.Echo("tomorrow:         " + tomorrow  + "\r\n");

var yesterday = new Date();
yesterday.setDate(yesterday.getDate()-1);
WScript.Echo("yesterday:        " + yesterday  + "\r\n");

var lastweek = new Date();
lastweek.setDate(lastweek.getDate()-7);
WScript.Echo("last week:        " + lastweek  + "\r\n");



WScript.Echo("getDate1():       " + getDate1() + "\r\n" +
			 "getDate2():       " + getDate2() + "\r\n" 
			);




// YYYYMMDD_HHMMSS
function getDate1() 
{
	var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
	var today = new Date();
	return (today.getYear() + f2d(today.getMonth() + 1) + f2d(today.getDate()) + "_"
			+ f2d(today.getHours()) + f2d(today.getMinutes()) + f2d(today.getSeconds()));
}

// YYYY/MM/DD HH:MM:SS
function getDate2() {
	var f2d = function( i ) { return (i < 10) ? ("0" + i) : ("" + i); };
	var today = new Date();
	return (today.getYear() + "/" + (today.getMonth() + 1) + "/" + today.getDate() + " "
			+ f2d(today.getHours()) + ":" + f2d(today.getMinutes()) + ":" + f2d(today.getSeconds()));
}
