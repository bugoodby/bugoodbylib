#include "stdafx.h"
#include "main.h"

/* dialog box message cracker */
#define HANDLE_DLG_MSG(hWnd, message, fn)						\
   case (message): return (SetDlgMsgResult(hWnd, uMsg,			\
      HANDLE_##message((hWnd), (wParam), (lParam), (fn))))



//-------------------------------------------------------------------
//! click [Start] button
//-------------------------------------------------------------------
void MainDlg_OnClickBtnStart(HWND hwnd)
{
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_START), FALSE);
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_STOP), TRUE);
}

//-------------------------------------------------------------------
//! click [Stop] button
//-------------------------------------------------------------------
void MainDlg_OnClickBtnStop(HWND hwnd)
{
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_START), TRUE);
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_STOP), FALSE);
}

//-------------------------------------------------------------------
// WM_INITDIALOG
//-------------------------------------------------------------------
BOOL MainDlg_OnInitDialog(HWND hwnd, HWND hwndFocus, LPARAM lParam)
{
	// .icoファイルのロード
	HICON hIcon = ::LoadIcon(g_hInst, MAKEINTRESOURCE(IDI_ICON1));
	::SendMessage(hwnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
	
	// 中心に移動
	{
		int wFull = ::GetSystemMetrics(SM_CXSCREEN);
		int hFull = ::GetSystemMetrics(SM_CYSCREEN);
		RECT rc;
		::GetWindowRect(hwnd, &rc);
		int w = rc.right - rc.left;
		int h = rc.bottom - rc.top;
		::MoveWindow(hwnd, (wFull-w)/2, (hFull-h)/2, w, h, FALSE);
	}
	
	// Aboutメニュー追加
	{
		HMENU hSysMenu = ::GetSystemMenu(hwnd, FALSE);
		if ( hSysMenu ) {
			int count = ::GetMenuItemCount(hSysMenu);
			if ( count > 0 ) {
				::InsertMenuA(hSysMenu, count - 1, MF_SEPARATOR | MF_BYPOSITION, 0, NULL);
				::InsertMenuA(hSysMenu, count - 1, MF_STRING | MF_BYPOSITION, IDM_ABOUTBOX, "About xxx...");
			}
		}
	}
	
	// 
	{
		HWND hCombo = ::GetDlgItem(hwnd, IDC_COMBO1);
		ComboBox_AddString(hCombo, L"aaa");
		ComboBox_AddString(hCombo, L"bbb");
		ComboBox_AddString(hCombo, L"ccc");
		ComboBox_AddString(hCombo, L"ddd");
	}
	
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_START), TRUE);
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_STOP), FALSE);
	
	return TRUE;
}

//-------------------------------------------------------------------
// WM_SIZE
//-------------------------------------------------------------------
void MainDlg_OnSize(HWND hwnd, UINT state, int cx, int cy)
{
	return;
}

//-------------------------------------------------------------------
// WM_COMMAND
//-------------------------------------------------------------------
void MainDlg_OnCommand(HWND hwnd, int id, HWND hwndCtl, UINT codeNotify)
{
	switch ( id )
	{
	case IDC_BTN_START:
		if ( codeNotify == BN_CLICKED ) {
			MainDlg_OnClickBtnStart(hwnd);
		}
		break;
	case IDC_BTN_STOP:
		if ( codeNotify == BN_CLICKED ) {
			MainDlg_OnClickBtnStop(hwnd);
		}
		break;
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
// WM_DESTROY
//-------------------------------------------------------------------
void MainDlg_OnDestroy(HWND hwnd)
{
	return;
}

//-------------------------------------------------------------------
// Dialog Procedure
//-------------------------------------------------------------------
INT_PTR CALLBACK MainDlg_Proc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam )
{
	switch ( uMsg )
	{
	HANDLE_DLG_MSG(hwnd, WM_INITDIALOG,		MainDlg_OnInitDialog);
	HANDLE_DLG_MSG(hwnd, WM_SIZE,			MainDlg_OnSize);
	HANDLE_DLG_MSG(hwnd, WM_COMMAND,		MainDlg_OnCommand);
	HANDLE_DLG_MSG(hwnd, WM_DESTROY,		MainDlg_OnDestroy);
	case WM_SYSCOMMAND:
		if ( ((UINT)wParam & 0xFFF0) == IDM_ABOUTBOX ) {
			// Show About box
			::DialogBox(g_hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hwnd, AboutDlg_Proc);
		}
	default:
		break;
	}
	return (INT_PTR)false;
}


