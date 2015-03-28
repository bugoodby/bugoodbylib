#pragma once

#include "Resource.h"

/* dialog box message cracker */
#define HANDLE_DLG_MSG(hWnd, message, fn)						\
   case (message): return (SetDlgMsgResult(hWnd, uMsg,			\
      HANDLE_##message((hWnd), (wParam), (lParam), (fn))))


extern HINSTANCE g_hInst;
extern HMODULE g_hModule;

INT_PTR CALLBACK AboutDlg_Proc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam );
INT_PTR CALLBACK MainDlg_Proc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam );

