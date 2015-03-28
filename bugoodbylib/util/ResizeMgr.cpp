/*! 
 * @file    dialog_resize.cpp
 * @brief   class CResizeMgr
 *
 * @author  
 */
#include "stdafx.h"
#include "ResizeMgr.h"

///////////////////////////////////////////////////////////////
//
// CResizeMgr
//
///////////////////////////////////////////////////////////////

//-------------------------------------------------------------
//! constructor
//-------------------------------------------------------------
CResizeMgr::CResizeMgr()
: m_bInitialized(FALSE), m_hDlg(NULL)
{
	m_sizDlg.cx = m_sizDlg.cy = 0;
}

//-------------------------------------------------------------
//! destructor
//-------------------------------------------------------------
CResizeMgr::~CResizeMgr()
{
	Term();
}

//-------------------------------------------------------------
//! @brief ����������
//! @param[in] hDlg �Ώۃ_�C�A���O�̃n���h��
//! @return TRUE on success, FALSE on failure.
//! @note Init()���Ăяo���T�u�v���V�[�W��
//-------------------------------------------------------------
BOOL CResizeMgr::x_InitInstance( HWND hDlg )
{
	RECT rect = {0};

	// if already initialized, terminate first.
	if ( m_bInitialized ) {
		Term();
	}

	if ( hDlg <= 0 ) {
		goto EXIT;
	}
	m_hDlg = hDlg;

	// get client rect of the dialog.
	if ( !::GetClientRect(m_hDlg, &rect) ) {
		goto EXIT;
	}
	m_sizDlg.cx = rect.right - rect.left;
	m_sizDlg.cy = rect.bottom - rect.top;

	// initialize the child controls information.
	if ( !::EnumChildWindows(m_hDlg, EnumChildProc, (LPARAM)this) ) {
		goto EXIT;
	}
	m_bInitialized = TRUE;

EXIT:
	return m_bInitialized;
}

//-------------------------------------------------------------
//! @brief �_�C�A���O�����T�C�Y����
//! @param[in] cx ���T�C�Y��̃T�C�Y(X����)
//! @param[in] cy ���T�C�Y��̃T�C�Y(Y����)
//! @return TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CResizeMgr::x_setDlgSize( LONG cx, LONG cy )
{
	RECT rect = {0};
	BOOL bRet = FALSE;

	if ( !::GetWindowRect(m_hDlg, &rect) ) {
		goto EXIT;
	}
	
	if ( !::MoveWindow(m_hDlg, rect.left, rect.top, cx, cy, TRUE) ) {
		goto EXIT;
	}

	bRet = TRUE;

EXIT:
	return bRet;
}


//-------------------------------------------------------------
//! @brief ����������
//! @param[in] hDlg �Ώۃ_�C�A���O�̃n���h��
//! @param[in] bRedraw TRUE�Ȃ�_�C�A���O��WM_SIZE���|�X�g����
//! @return TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CResizeMgr::Init( HWND hDlg, BOOL bRedraw )
{
	RECT rect = {0};
	BOOL bRet = TRUE;

	if ( !x_InitInstance(hDlg) ) {
		return FALSE;
	}

	if ( bRedraw ) {
		// send WM_SIZE to refresh child controls.
		bRet = ::PostMessage( hDlg, WM_SIZE, SIZE_RESTORED, MAKELONG(m_sizDlg.cx, m_sizDlg.cy) );
	}

	return bRet;
}

//-------------------------------------------------------------
//! @brief ����������\n
//!        �����đΏۃ_�C�A���O�����T�C�Y����
//! @param[in] hDlg �Ώۃ_�C�A���O�̃n���h��
//! @param[in] cx ���T�C�Y��̃T�C�Y(X����)
//! @param[in] cy ���T�C�Y��̃T�C�Y(Y����)
//! @return TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CResizeMgr::Init( HWND hDlg, LONG cx, LONG cy )
{
	BOOL bRet = TRUE;

	if ( !x_InitInstance(hDlg) ) {
		return FALSE;
	}

	bRet = x_setDlgSize( cx, cy );
	
	return bRet;
}

//-------------------------------------------------------------
//! @brief �I������
//! @return (void)
//-------------------------------------------------------------
void CResizeMgr::Term()
{
	CONTROLDATA *pcpd = NULL;
	std::vector<CONTROLDATA*>::iterator it;
	
	for ( it = m_data.begin(); it != m_data.end(); it++ ) {
		pcpd = *it;
		free( pcpd );
	}
	m_data.clear();
	m_bInitialized = FALSE;
	m_hDlg = NULL;
	m_sizDlg.cx = m_sizDlg.cy = 0;
}

//-------------------------------------------------------------
//! @brief EnumChildProc()�v���[�X�z���_�̎���
//! @param[in] hWnd �e�R���g���[���̃n���h��
//! @param[in] lParam CResizeMgr�C���X�^���X�ւ̃|�C���^
//! @return TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CALLBACK CResizeMgr::EnumChildProc( HWND hWnd, LPARAM lParam )
{
    CResizeMgr *pMgr = (CResizeMgr*)lParam;
	CONTROLDATA *pcpd = NULL;
	RECT rect = {0};
	POINT point1 = {0}, point2 = {0};
	BOOL bRet = FALSE;

	if ( !hWnd || !pMgr ) {
		goto EXIT;
	}

	/* Is hWnd a child of the dialog? */
	if ( ::GetParent(hWnd) != pMgr->m_hDlg ) {
		goto EXIT;
	}

	/* alloc memory */
	pcpd = (CONTROLDATA*)malloc( sizeof(CONTROLDATA) );
	if ( !pcpd ) {
		goto EXIT;
	}
	memset( pcpd, 0x00, sizeof(CONTROLDATA) );
	
	/* fill CTRLPOSDATA structure */
	pcpd->hWnd = hWnd;
	pcpd->nID = ::GetDlgCtrlID( hWnd );
	if ( pcpd->nID == 0 ) {
		goto EXIT;
	}
	if ( !::GetWindowRect( hWnd, &rect ) ) {
		goto EXIT;
	}
	point1.x = rect.left; point1.y = rect.top;
	point2.x = rect.right; point2.y = rect.bottom;
	
	if ( !::ScreenToClient( pMgr->m_hDlg, &point1 ) ) {
		goto EXIT;
	}
	if ( !::ScreenToClient( pMgr->m_hDlg, &point2 ) ) {
		goto EXIT;
	}
	pcpd->origin.x = point1.x;
	pcpd->origin.y = point1.y;
	pcpd->size.cx = point2.x - point1.x;
	pcpd->size.cy = point2.y - point1.y;

	pMgr->m_data.push_back( pcpd );
	bRet = TRUE;

EXIT:
	if ( !bRet && pcpd ) free( pcpd );
	return TRUE;
}

//-------------------------------------------------------------
//! @brief �R���g���[���̈ʒu����уT�C�Y�̍������w�肵�čX�V����.\n
//!        (DeferWindowPos�ɂ��X�V)
//! @param[in] nIndex �ΏۃR���g���[����m_data�ɂ�����C���f�b�N�X
//! @param[in] hWinPosInfo �����E�B���h�E�ʒu�\���̂̃n���h��
//! @param[in] x  �����ʒu����̍���(X����)
//! @param[in] y  �����ʒu����̍���(Y����)
//! @param[in] cx �����T�C�Y����̍���(X����)
//! @param[in] cy �����T�C�Y����̍���(Y����)
//! @return �X�V���ꂽ�����E�B���h�E�ʒu�\���̂̃n���h��.\n
//!         ���s�����Ƃ���NULL.
//-------------------------------------------------------------
HDWP CResizeMgr::DeferWindowPos( UINT nIndex, HDWP hWinPosInfo, LONG x, LONG y, LONG cx, LONG cy )
{
	CONTROLDATA *pcpd = NULL;
	
	pcpd = m_data.at(nIndex);
	if ( !pcpd ) {
		return hWinPosInfo;
	}

	return ::DeferWindowPos( hWinPosInfo,
							 pcpd->hWnd, 
							 0,
							 pcpd->origin.x + x, 
							 pcpd->origin.y + y, 
							 pcpd->size.cx + cx, 
							 pcpd->size.cy + cy, 
							 SWP_NOZORDER );
}

