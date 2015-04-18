#include "stdafx.h"
#include "main.h"
#include "stdio.h"
#include <string>

/* dialog box message cracker */
#define HANDLE_DLG_MSG(hWnd, message, fn)						\
   case (message): return (SetDlgMsgResult(hWnd, uMsg,			\
      HANDLE_##message((hWnd), (wParam), (lParam), (fn))))


LPWSTR to_wstring( LPCSTR psz, UINT codePage )
{
	if ( !psz ) {
		return NULL;
	}

	int len = ::MultiByteToWideChar(codePage, 0, psz, -1, NULL, 0);
	if ( len == 0 ) {
		return NULL;
	}
	LPWSTR buffer = (LPWSTR)malloc(len * sizeof(WCHAR));
	if ( !buffer ) {
		return NULL;
	}

	len = ::MultiByteToWideChar(codePage, 0, psz, -1, buffer, len);
	if ( len == 0 ) {
		free(buffer);
		return NULL;
	}
	
	return buffer;
}

void log( HWND hwnd, const wchar_t *format, ... )
{
	HWND hEdit = ::GetDlgItem(hwnd, IDC_EDIT1);
	
	va_list argp;
	va_start( argp, format );
	
	size_t buf_len = _vscwprintf(format, argp) + 1;
	wchar_t *pBuffer = (wchar_t*)malloc(buf_len * sizeof(wchar_t));

	if ( pBuffer ) {
		vswprintf_s(pBuffer, buf_len, format, argp);
		
		int len = ::GetWindowTextLength(hEdit);
		::SendMessage(hEdit, EM_SETSEL, len, len);
		::SendMessage(hEdit, EM_REPLACESEL, 0, (LPARAM)pBuffer);
		
		free(pBuffer);
	}

	va_end( argp );
	return;
}

void log( HWND hwnd, const char *format, ... )
{
	HWND hEdit = ::GetDlgItem(hwnd, IDC_EDIT1);
	
	va_list argp;
	va_start( argp, format );
	
	size_t buf_len = _vscprintf(format, argp) + 1;
	char *pBuffer = (char*)malloc(buf_len * sizeof(char));

	if ( pBuffer ) {
		vsprintf_s(pBuffer, buf_len, format, argp);
		wchar_t *pBufferW = to_wstring(pBuffer, CP_ACP);
		
		if ( pBufferW ) {
			int len = ::GetWindowTextLength(hEdit);
			::SendMessage(hEdit, EM_SETSEL, len, len);
			::SendMessage(hEdit, EM_REPLACESEL, 0, (LPARAM)pBufferW);
			free(pBufferW);
		}

		free(pBuffer);
	}

	va_end( argp );
	return;
}

//-------------------------------------------------------------------
//! click [Start] button
//-------------------------------------------------------------------
void MainDlg_OnClickBtnStart(HWND hwnd)
{
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_START), FALSE);
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_STOP), TRUE);
	
	log(hwnd, L"MainDlg_OnClickBtnStart( hwnd=0x%x )\n", hwnd);
}

//-------------------------------------------------------------------
//! click [Stop] button
//-------------------------------------------------------------------
void MainDlg_OnClickBtnStop(HWND hwnd)
{
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_START), TRUE);
	Button_Enable(::GetDlgItem(hwnd, IDC_BTN_STOP), FALSE);
	
	log(hwnd, "MainDlg_OnClickBtnStop( hwnd=0x%x )\n", hwnd);
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
	
	wchar_t *str = L"This is a EditBox\r\n";
	HWND hEdit = ::GetDlgItem(hwnd, IDC_EDIT1);
	::SendMessage(hEdit, EM_REPLACESEL, 0, (LPARAM)str);

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


