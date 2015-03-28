/*! 
 * @file    dialog_resize.h
 * @brief   class CResizeMgr
 *
 * @author  
 */
#ifndef _DIALOG_RESIZE_H_
#define _DIALOG_RESIZE_H_

#include <vector>

//! CResizeMgr内部で使用する構造体
typedef struct tagCONTROLDATA {
    UINT	nID;		//!< control ID
	HWND	hWnd;		//!< control handle
	POINT	origin;		//!< initial position
	SIZE	size;		//!< initial size
} CONTROLDATA;

//! CResizeMgrで使用するマジックナンバー
#define NOT_CARE -1


///////////////////////////////////////////////////////////////
//
//  CResizeMgr
//! @brief 
//
///////////////////////////////////////////////////////////////
class CResizeMgr
{
private:
	BOOL m_bInitialized;					//!< 初期化されたらTRUE
    HWND m_hDlg;							//!< dialog handle
	SIZE m_sizDlg;							//!< initial dialog size
    std::vector<CONTROLDATA*> m_data;		//!< child controls data

	BOOL	x_InitInstance( HWND hWnd );
	BOOL	x_setDlgSize( LONG cx, LONG cy );
	static BOOL CALLBACK EnumChildProc( HWND hwnd, LPARAM lParam );

public:
	CResizeMgr();
	~CResizeMgr();

	BOOL	Init( HWND hWnd, BOOL bRedraw = TRUE );
	BOOL	Init( HWND hWnd, LONG cx, LONG cy );
	void	Term();
	HDWP	DeferWindowPos( UINT nIndex, HDWP hWinPosInfo, LONG x, LONG y, LONG cx, LONG cy );

	inline HWND			GetDlgHwnd()			{ return m_hDlg; };
	inline SIZE			GetDlgBaseSize()		{ return m_sizDlg; };
	inline UINT			GetCtrlCount()			{ return (UINT)m_data.size(); };
	inline CONTROLDATA*	GetCtrlData( UINT i )	{ return m_data.at(i); }
};

#define DLGRESIZE_BEGIN( _obj, _cx, _cy )																\
	{																									\
		CResizeMgr *__static_pDlgResize = &(_obj);														\
		CONTROLDATA *__static_pcpd = NULL;																\
		SIZE __static__size = __static_pDlgResize->GetDlgBaseSize();									\
		__static__size.cx = (_cx) - __static__size.cx;													\
		__static__size.cy = (_cy) - __static__size.cy;													\
		HDWP __static_hWinPosInfo = ::BeginDeferWindowPos(__static_pDlgResize->GetCtrlCount());			\
		for ( UINT __static_i = 0; __static_i < __static_pDlgResize->GetCtrlCount(); __static_i++ ) {	\
			__static_pcpd = __static_pDlgResize->GetCtrlData(__static_i);								\
			if ( !__static_pcpd || !__static_hWinPosInfo ) continue;									\
			switch ( __static_pcpd->nID ) {

#define DLGRESIZE_MOVE( _id, _x, _y, _cx, _cy )															\
			case (_id):																					\
				__static_hWinPosInfo = __static_pDlgResize->DeferWindowPos( __static_i,					\
								__static_hWinPosInfo,													\
								(_x <= 0) ? 0 : __static__size.cx * (LONG)(_x) / 100,					\
								(_y <= 0) ? 0 : __static__size.cy * (LONG)(_y) / 100,					\
								(_cx <= 0) ? 0 : __static__size.cx * (LONG)(_cx) / 100,					\
								(_cy <= 0) ? 0 : __static__size.cy * (LONG)(_cy) / 100 );				\
				break;																					\

#define DLGRESIZE_END																					\
			default:																					\
				__static_hWinPosInfo = __static_pDlgResize->DeferWindowPos( __static_i,					\
								__static_hWinPosInfo,													\
								0,																		\
								0,																		\
								0,																		\
								0);																		\
				break;																					\
			}																							\
		}																								\
		if ( __static_hWinPosInfo ) ::EndDeferWindowPos(__static_hWinPosInfo);							\
		::InvalidateRect(__static_pDlgResize->GetDlgHwnd(), NULL, TRUE);								\
	}




#endif	/* _DIALOG_RESIZE_H_ */
