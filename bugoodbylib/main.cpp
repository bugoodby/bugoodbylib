#include "stdafx.h"
#include "main.h"

/* --- global variables --- */
HINSTANCE g_hInst = NULL;
HMODULE g_hModule = NULL;

//-------------------------------------------------------------------
// main
//-------------------------------------------------------------------
int APIENTRY _tWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	g_hInst = hInstance;
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
	::SetDllDirectoryA("");
	
	HWND hwnd = ::FindWindowA("#32770", "Dialog");
	if ( ::IsWindow(hwnd) ) {
		::SetForegroundWindow(hwnd);
	}
	else {
		// Show main window
		::DialogBox(hInstance, MAKEINTRESOURCE(IDD_DIALOG1), NULL, MainDlg_Proc);
	}

	return 0;
}

