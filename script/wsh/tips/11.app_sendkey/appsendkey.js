main();

function main() 
{
	var appTitle = "–³‘è - ƒƒ‚’ ";
	var wshShell = new ActiveXObject("WScript.Shell");
	
	//ƒƒ‚’ ‚ğ‹N“®
	wshShell.Run("C:\\Windows\\System32\\notepad.exe", 1, false);
	
	WScript.Sleep(1000);
	
	wshShell.AppActivate(appTitle);
	wshShell.SendKeys("This is a test file. You can delete it.");
	wshShell.SendKeys("%F");		// Alt+F
	wshShell.SendKeys("{DOWN}");	// «
	wshShell.SendKeys("{DOWN}");	// «
	wshShell.SendKeys("{DOWN}");	// «
	wshShell.SendKeys("~");			// Enter
	WScript.Sleep(1000);
	wshShell.SendKeys("SendKeyTest.txt");
	wshShell.SendKeys("{ESC}");		// Esc
	wshShell.SendKeys("%{F4}");		// Alt+F4
	WScript.Sleep(1000);
	wshShell.SendKeys("%N");		// Alt+N
}
