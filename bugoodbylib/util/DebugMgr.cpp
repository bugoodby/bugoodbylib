/*! 
 * @file    DebugMgr.cpp
 * @brief   Debugging Utilities
 *
 * @author  
 */
#include "stdafx.h"
#include "DebugMgr.h"
#include <stdio.h>
#include <stdlib.h>

/* for debug output */
static const unsigned long g_ulMessageSize = 1024;
static const unsigned long g_ulMessageSizeW = 1024;
static FILE* g_pDebugFile = NULL;


//////////////////////////////////////////////////////////////////


inline void _dbgOutputStringW( const wchar_t *pwsz )
{
	if ( g_pDebugFile ) fputws( pwsz, g_pDebugFile );
	else                 ::OutputDebugStringW( pwsz );
}

inline void _dbgOutputStringA( const char *psz )
{
	if ( g_pDebugFile ) fputs( psz, g_pDebugFile );
	else                 ::OutputDebugStringA( psz );
}

static bool _is_utf16_char_exCRLF( wchar_t ch )
{
	WORD wCharType;
	::GetStringTypeW( CT_CTYPE1, &ch, 1, &wCharType );
	if ( wCharType & (C1_CNTRL) ) {
		return false;
	}

	switch ( ch )
	{
	case L'\r':
	case L'\n':
		return false;
	default:
		return true;
	}
}

//////////////////////////////////////////////////////////////////

//-------------------------------------------------------------
//! @brief      �f�o�b�O�@�\�̊J�n
//! @return     �������ɐ���������TRUE, ����ȊO��FALSE.
//! @note       �v���O�����J�n���Ɉ�x�������s����Ȃ���΂Ȃ�Ȃ��B\n
//              �{�֐������s�O��debug output�֐����g���Ă͂����Ȃ�
//-------------------------------------------------------------
void dbgInitialize()
{
	wchar_t drive[_MAX_DRIVE] = L"";
	wchar_t dir[_MAX_DIR] = L"";
	wchar_t fname[_MAX_FNAME] = L"";
	wchar_t wszPathBuf[MAX_PATH] = L"";
	
	::OutputDebugStringW( L"*** [dbgInitialize] ***\n" );
	
	DWORD dwRet = ::GetModuleFileNameW( NULL, wszPathBuf, MAX_PATH );
	if ( dwRet != 0 ) {
		_wsplitpath_s( wszPathBuf, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0 );
		wcscpy_s( wszPathBuf, MAX_PATH, drive );
		wcscat_s( wszPathBuf, MAX_PATH, dir );
		wcscat_s( wszPathBuf, MAX_PATH, L"DebugLog.txt" );
	}
	
	errno_t err = _wfopen_s(&g_pDebugFile, wszPathBuf, L"w" );
	if ( err != 0 ) {
		::OutputDebugStringW( L"Could not open debug output file.\n" );
		::OutputDebugStringW( wszPathBuf );
		::OutputDebugStringW( L"\n" );
		g_pDebugFile = NULL;
	}
	else {
		SYSTEMTIME st = {0};
		::GetLocalTime( &st );
		dbgLoggingW(L"=== dbgInitialize %s(pid:%d) [%04d/%02d/%02d %02d:%02d:%02d] ===\n",
			fname, ::GetCurrentProcessId(), st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond);
	}
	
	return;
}

//-------------------------------------------------------------
//! @brief      �f�o�b�O�@�\�̏I��
//! @return     �������ɐ���������TRUE, ����ȊO��FALSE.
//! @note       �v���O�����I�����Ɉ�x�������s����Ȃ���΂Ȃ�Ȃ��B\n
//              �{�֐������s���debug output�֐����g���Ă͂����Ȃ�
//-------------------------------------------------------------
void dbgTerminate()
{
	::OutputDebugStringW( L"*** [dbgTerminate] ***\n" );

	if ( g_pDebugFile ) {
		fclose( g_pDebugFile );
		g_pDebugFile = NULL;
	}

	return;
}


//-------------------------------------------------------------
//! @brief      UNICODE������̃f�o�b�O���O���o�͂���
//! @param[in]  format ����
//! @return     (void)
//-------------------------------------------------------------
void dbgLoggingW( const wchar_t *format, ... )
{
	wchar_t szBuf[g_ulMessageSizeW] = L"";
	
	va_list argp;
	va_start( argp, format );
	_vsnwprintf_s(szBuf, g_ulMessageSizeW, g_ulMessageSizeW - 1, format, argp);
	va_end( argp );
	
	_dbgOutputStringW(szBuf);
}

//-------------------------------------------------------------
//! @brief      MBCS������̃f�o�b�O���O���o�͂���
//! @param[in]  format ����
//! @return     (void)
//-------------------------------------------------------------
void dbgLoggingA( const char *format, ... )
{
	char szBuf[g_ulMessageSize] = "";
	
	va_list argp;
	va_start( argp, format );
	_vsnprintf_s(szBuf, g_ulMessageSize, g_ulMessageSize - 1, format, argp);
	va_end( argp );
	
	_dbgOutputStringA(szBuf);
}


//-------------------------------------------------------------
//! @brief      �������_���v�����O�o�͂���
//! @param[in]  pData �_���v�Ώۃ������u���b�N�̐擪�|�C���^
//! @param[in]  size pData�̃o�C�g��
//! @return     (void)
//-------------------------------------------------------------
void dbgDumpW( const void *pData, size_t size )
{
	const wchar_t wszHexArray[] = L"0123456789ABCDEF";
	const unsigned char *p = (const unsigned char*)pData;
	size_t l, line = 0;
	wchar_t lineBuf[58] = {0};
	wchar_t *pHexPtr, *pChrPtr;
	wchar_t ch;
	
	lineBuf[56] = L'\n';
	
	dbgLoggingW( L" 0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +A +B +C +D +E +F  0            +F\n" );
	dbgLoggingW( L"----------------------------------------------- ----------------\n" );
	
	do {
		line = ( size > 16 ) ? 16 : size;
		size -= line;
		
		for ( int i = 0; i < 56; i++ ) lineBuf[i] = L' ';
		pHexPtr = lineBuf;
		pChrPtr = lineBuf + 48;
		
		for ( l = 0; l < line; l++, p++ ) {
			*pHexPtr++ = wszHexArray[ *p >> 4 ];
			*pHexPtr++ = wszHexArray[ *p & 0xF ];
			pHexPtr++;

			if ( !(l % 2) ) {
				if ( l == line - 1 ) {
					*pChrPtr++ = L'.';
				} else {
					ch = *(const wchar_t*)p;
					*pChrPtr++ = ( _is_utf16_char_exCRLF(ch) ) ? ch : L'.';
				}
			}
		}
		dbgLoggingW( lineBuf );
		
	} while ( size > 0 );
	
	dbgLoggingW( L"----------------------------------------------- ----------------\n" );
}

//-------------------------------------------------------------
//! @brief      �������_���v�����O�o�͂���
//! @param[in]  pData �_���v�Ώۃ������u���b�N�̐擪�|�C���^
//! @param[in]  size pData�̃o�C�g��
//! @return     (void)
//-------------------------------------------------------------
void dbgDumpA( const void *pData, size_t size )
{
	const char szHexArray[] = "0123456789ABCDEF";
	const unsigned char *p = (const unsigned char*)pData;
	size_t l, line = 0;
	char lineBuf[66] = {0};
	char *pHexPtr, *pChrPtr;
	
	lineBuf[64] = '\n';
	
	dbgLoggingA( " 0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +A +B +C +D +E +F  0            +F\n" );
	dbgLoggingA( "----------------------------------------------- ----------------\n" );
	
	do {
		line = ( size > 16 ) ? 16 : size;
		size -= line;
		
		for ( int i = 0; i < 64; i++ ) lineBuf[i] = ' ';
		pHexPtr = lineBuf;
		pChrPtr = lineBuf + 48;
		
		for ( l = 0; l < line; l++, p++ ) {
			*pHexPtr++ = szHexArray[ *p >> 4 ];
			*pHexPtr++ = szHexArray[ *p & 0xF ];
			pHexPtr++;
			*pChrPtr++ = ( (0x20<=*p)&&(*p<=0x7E) ) ? *p : '.';
		}
		dbgLoggingA( lineBuf );
		
	} while ( size > 0 );
	
	dbgLoggingA( "----------------------------------------------- ----------------\n" );
}


