/*! 
 * @file    strpool.cpp
 * @brief   ������o�b�t�@
 *
 * @author  
 */
#include "stdafx.h"
#include "DebugMgr.h"
#include "strpool.h"
#include <strsafe.h>

//---------------------------------------------------------------
//! constructor
//! @param[in] maxsize �o�b�t�@�̍ő�T�C�Y(WCHAR�P��)
//! @param[in] blocksize ���������Ċm�ۂ���P�ʃT�C�Y(WCHAR�P��)
//---------------------------------------------------------------
CStrPool::CStrPool( size_t maxsize /* = 65536 */, size_t blocksize /* = 1024 */ )
{
	if ( blocksize == 0 ) {
		blocksize = 1024;
	}
	if ( maxsize == 0 ) {
		maxsize = 65536;
	}
	if ( blocksize > maxsize ) {
		LOG(_T("too large blocksize. block=%u, max=%u\n"), blocksize, maxsize);
		blocksize = maxsize;
	}
	
	m_blocksize = blocksize;
	m_maxsize = maxsize;
	
	m_psz = 0;
	m_size = 0;
	m_len = 0;
	
	x_reallocMemory(m_blocksize);
}


//---------------------------------------------------------------
//! destructor
//---------------------------------------------------------------
CStrPool::~CStrPool(void)
{
	if ( m_psz )
	{
		free(m_psz);
		m_psz = NULL;
	}
	m_len = 0;
	m_size = 0;
}

//-------------------------------------------------------------
//! @brief     size�������̃��������Ċm�ۂ���
//! @param[in] size �m�ۂ��郁�����T�C�Y
//! @return    TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::x_reallocMemory( size_t size )
{
	m_psz = (LPWSTR)realloc( m_psz, sizeof(WCHAR) * size );
	if ( m_psz ) {
		m_size = size;
		if ( m_len == 0 ) {
			memset(m_psz, 0, sizeof(WCHAR) * m_size);
		}
	} else {
		LOG(_T("realloc() failed. (err=0x%x)\n"), ::GetLastError());
		m_len = 0;
		m_size = 0;
	}
	
	return (m_psz != NULL);
}

//-------------------------------------------------------------
//! @brief      string_len�����̕����������̂ɏ\���ȃ��������Ċm�ۂ���
//! @param[in]  string_len ������̒���
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::x_reallocEnoughMemory( size_t string_len )
{
	if ( string_len >= m_maxsize ) {
		LOG(_T("too large buffer is needed. need=%u, max=%u\n"), string_len, m_maxsize);
		return FALSE;
	}
	
	if ( string_len >= m_size )
	{
		size_t new_size = m_size;

		do {
			new_size += m_blocksize;
		} while ( string_len >= new_size );
		
		return x_reallocMemory(new_size);
	}
	
	return (m_psz != NULL);
}

//-------------------------------------------------------------
//! @brief      MBCS�������Unicode������ɕϊ�����
//! @param[in]  pszText MBCS������
//! @return     �ϊ����ꂽUnicode������ւ̃|�C���^. \n
//!             �g�p���free()���邱��. ���s����NULL���Ԃ�.
//-------------------------------------------------------------
LPWSTR CStrPool::x_convertToUnicode( LPCSTR pszText )
{
	LPWSTR pwszText = NULL;
	int iNeedChars = 0;
	
	iNeedChars = ::MultiByteToWideChar(CP_ACP, 0, pszText, -1, NULL, 0);
	if ( iNeedChars <= 0 ) {
		LOG(_T("MultiByteToWideChar() failed. (err=0x%x)\n"), ::GetLastError());
		return NULL;
	}
	pwszText = (LPWSTR)malloc(sizeof(WCHAR) * iNeedChars);
	if ( !pwszText ) {
		LOG(_T("malloc() failed. (err=0x%x)\n"), ::GetLastError());
		return NULL;
	}
	if ( ::MultiByteToWideChar(CP_ACP, 0, pszText, -1, pwszText, iNeedChars) == 0 ) {
		LOG(_T("MultiByteToWideChar() failed. (err=0x%x)\n"), ::GetLastError());
		free(pwszText);
		return NULL;
	}
	
	return pwszText;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@����ɂ���
//! @return     (void)
//-------------------------------------------------------------
void CStrPool::Empty()
{
	if ( m_psz ) {
		m_psz[0] = L'\0';
	}
	m_len = 0;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽUnicode�������ݒ肷��
//! @param[in]  format �����̎w��
//! @param[in]  argp �������X�g�ւ̃|�C���^
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::FormatVW( LPCWSTR format, va_list argp )
{
	size_t sizAdd = _vscwprintf(format, argp);

	if ( sizAdd >= m_size ) {
		// buffer is not enough.
		if ( !x_reallocEnoughMemory(sizAdd) ) {
			return FALSE;
		}
	}
	
	vswprintf_s(m_psz, m_size, format, argp);
	m_len = sizAdd;
	
	return TRUE;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽMBCS�������ݒ肷��
//! @param[in]  format �����̎w��
//! @param[in]  argp �������X�g�ւ̃|�C���^
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::FormatVA( LPCSTR format, va_list argp )
{
	BOOL bRet = FALSE;
	LPSTR pszText = NULL;
	LPWSTR pwszText = NULL;

	int len = _vscprintf(format, argp) + 1;		// �I�[�R�[�h���܂߂邽��+1
	pszText = (LPSTR)malloc(len);
	if ( !pszText ) {
		LOG(_T("malloc() failed. (err=0x%x)\n"), ::GetLastError());
		goto EXIT;
	}
	vsprintf_s(pszText, len, format, argp);
	
	// Get the UNICODE string from the input string.
	pwszText = x_convertToUnicode(pszText);
	if ( !pwszText ) {
		goto EXIT;
	}
	
	size_t sizAdd = wcslen(pwszText);
	if ( sizAdd >= m_size ) {
		// buffer is not enough.
		if ( !x_reallocEnoughMemory(sizAdd) ) {
			goto EXIT;
		}
	}
	
	wcscat_s(m_psz, m_size, pwszText);
	m_len = sizAdd;
	
	bRet = TRUE;
	
EXIT:
	if ( pszText ) free(pszText);
	if ( pwszText ) free(pwszText);
	return TRUE;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽUnicode�������ǉ�����
//! @param[in]  format �����̎w��
//! @param[in]  argp �������X�g�ւ̃|�C���^
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendFormatVW( LPCWSTR format, va_list argp )
{
	size_t sizAdd = _vscwprintf(format, argp);

	if ( m_len + sizAdd >= m_size ) {
		// buffer is not enough.
		if ( !x_reallocEnoughMemory(m_len + sizAdd) ) {
			return FALSE;
		}
	}
	
	vswprintf_s(m_psz + m_len, m_size - m_len, format, argp);
	m_len += sizAdd;
	
	return TRUE;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽMBCS�������ǉ�����
//! @param[in]  format �����̎w��
//! @param[in]  argp �������X�g�ւ̃|�C���^
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendFormatVA( LPCSTR format, va_list argp )
{
	BOOL bRet = FALSE;
	LPSTR pszText = NULL;

	int len = _vscprintf(format, argp) + 1;		// �I�[�R�[�h���܂߂邽��+1
	pszText = (LPSTR)malloc(len);
	if ( !pszText ) {
		LOG(_T("malloc() failed. (err=0x%x)\n"), ::GetLastError());
		goto EXIT;
	}
	vsprintf_s(pszText, len, format, argp);
	
	bRet = AppendA(pszText);
	
EXIT:
	if ( pszText ) free(pszText);
	return bRet;
}


//-------------------------------------------------------------
//! @brief      �o�b�t�@��Unicode�������ǉ�����
//! @param[in]  pszText �ǉ����镶����
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendW( LPCWSTR pszText )
{
	if ( !pszText ) {
		return FALSE;
	}
	
	size_t sizAdd = wcslen(pszText);
	if ( m_len + sizAdd >= m_size ) {
		// buffer is not enough.
		if ( !x_reallocEnoughMemory(m_len + sizAdd) ) {
			return FALSE;
		}
	}
	
	wcscat_s(m_psz + m_len, m_size - m_len, pszText);
	m_len += sizAdd;
	
	return TRUE;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@��MBCS�������ǉ�����
//! @param[in]  pszText �ǉ����镶����
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendA( LPCSTR pszText )
{
	BOOL bRet = FALSE;
	LPWSTR pwszText = NULL;
	
	if ( !pszText ) {
		goto EXIT;
	}
	
	// Get the UNICODE string from the input string.
	pwszText = x_convertToUnicode(pszText);
	if ( !pwszText ) {
		goto EXIT;
	}
	
	size_t sizAdd = wcslen(pwszText);
	if ( m_len + sizAdd >= m_size ) {
		// buffer is not enough.
		if ( !x_reallocEnoughMemory(m_len + sizAdd) ) {
			goto EXIT;
		}
	}
	
	wcscat_s(m_psz + m_len, m_size - m_len, pwszText);
	m_len += sizAdd;
	
	bRet = TRUE;
	
EXIT:
	if ( pwszText ) free(pwszText);
	return TRUE;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽUnicode�������ǉ�����
//! @param[in]  format �����̎w��
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendFormatW( LPCWSTR format, ... )
{
	BOOL bRet = FALSE;
	va_list argp;

	if ( !format ) { return FALSE; }
	va_start( argp, format );
	bRet = AppendFormatVW( format, argp );
	va_end( argp );
	
	return bRet;
}

//-------------------------------------------------------------
//! @brief      �o�b�t�@�ɏ����w�肳�ꂽMBCS�������ǉ�����
//! @param[in]  format �����̎w��
//! @return     TRUE on success, otherwise FALSE.
//-------------------------------------------------------------
BOOL CStrPool::AppendFormatA( LPCSTR format, ... )
{
	BOOL bRet = FALSE;
	va_list argp;

	if ( !format ) { return FALSE; }
	va_start( argp, format );
	bRet = AppendFormatVA( format, argp );
	va_end( argp );
	
	return bRet;
}

