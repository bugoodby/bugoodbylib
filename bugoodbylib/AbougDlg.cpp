#include "stdafx.h"
#include "main.h"


//-------------------------------------------------------------------
// WM_INITDIALOG (AboutBox)
//-------------------------------------------------------------------
BOOL AboutDlg_OnInitDialog(HWND hwnd, HWND hwndFocus, LPARAM lParam)
{
	// move to center.
	{
		int wFull = ::GetSystemMetrics(SM_CXSCREEN);
		int hFull = ::GetSystemMetrics(SM_CYSCREEN);
		RECT rc;
		::GetWindowRect(hwnd, &rc);
		int w = rc.right - rc.left;
		int h = rc.bottom - rc.top;
		::MoveWindow(hwnd, (wFull-w)/2, (hFull-h)/2, w, h, FALSE);
	}
	return TRUE;
}

//-------------------------------------------------------------------
// WM_COMMAND (AboutBox)
//-------------------------------------------------------------------
void AboutDlg_OnCommand(HWND hwnd, int id, HWND hwndCtl, UINT codeNotify)
{
	switch ( id )
	{
	case IDOK:
	case IDCANCEL:
		if ( codeNotify == BN_CLICKED ) {
			::EndDialog(hwnd, id);
		}
		break;
	default:
		break;
	}

	return;
}

//-------------------------------------------------------------------
// Dialog Procedure (AboutBox)
//-------------------------------------------------------------------
INT_PTR CALLBACK AboutDlg_Proc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam )
{
	switch ( uMsg )
	{
	HANDLE_DLG_MSG(hwnd, WM_INITDIALOG,		AboutDlg_OnInitDialog);
	HANDLE_DLG_MSG(hwnd, WM_COMMAND,		AboutDlg_OnCommand);
	default:
		break;
	}
	return (INT_PTR)false;
}

