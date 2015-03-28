/*! 
 * @file    SettingMgr.cpp
 * @brief   設定値の管理 (class CAppReg, CAppIni)
 *
 * @author  
 */
#include "stdafx.h"
#include "DebugMgr.h"
#include "SettingMgr.h"

//-------------------------------------------------------------
//! constructor
//-------------------------------------------------------------
CAppReg::CAppReg( LPCTSTR pszCompanyName, LPCTSTR pszAppName )
 : m_hSoftware(NULL),
   m_hCompany(NULL),
   m_hApplication(NULL)
{
	LONG lResult = 0;

	LOG(_T("> CAppReg( %s, %s )\n"), pszCompanyName, pszAppName);
	
	lResult = ::RegOpenKeyEx(HKEY_CURRENT_USER, _T("Software"), 0, KEY_READ|KEY_WRITE, &m_hSoftware);
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegOpenKeyEx(HKEY_CURRENT_USER\\Software) : 0x%x\n"), lResult);
		return;
	}
	
	lResult = ::RegCreateKeyEx(m_hSoftware, pszCompanyName, 0, NULL, REG_OPTION_NON_VOLATILE, 
					KEY_READ|KEY_WRITE,NULL, &m_hCompany, NULL);
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegCreateKeyEx(%s) : 0x%x\n"), m_hSoftware, lResult);
		return;
	}

	lResult = ::RegCreateKeyEx(m_hCompany, pszAppName, 0, NULL, REG_OPTION_NON_VOLATILE, 
					KEY_READ|KEY_WRITE,NULL, &m_hApplication, NULL);
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegCreateKeyEx(%s) : 0x%x\n"), pszAppName, lResult);
		return;
	}
	
	LOG(_T("< CAppReg()\n"));
}

//-------------------------------------------------------------
//! destructor
//-------------------------------------------------------------
CAppReg::~CAppReg()
{
	if ( m_hApplication )	::RegCloseKey(m_hApplication);
	if ( m_hCompany )		::RegCloseKey(m_hCompany);
	if ( m_hSoftware )		::RegCloseKey(m_hSoftware);
}

//-------------------------------------------------------------
//! @brief      指定されたセクションを開く（存在しなければ作成する）
//! @param[in]  pszSection セクション名
//! @return     セクションキーのハンドル
//-------------------------------------------------------------
HKEY CAppReg::GetSectionKey( LPCTSTR pszSection )
{
	HKEY hSectionKey = NULL;
	LONG lResult = 0;
	DWORD dwDisposition = 0;
	
	if ( !m_hApplication ) {
		LOG(_T("m_hApplication == NULL\n"));
		return NULL;
	}
	
	lResult = ::RegCreateKeyEx(m_hApplication, pszSection, 0, 0, REG_OPTION_NON_VOLATILE, 
					KEY_WRITE|KEY_READ, NULL, &hSectionKey, &dwDisposition);
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegCreateKeyEx(%s) : 0x%x\n"), pszSection, lResult);
		return NULL;
	}
	//LOG(_T("  key [%s] was opend. (dwDisposition = %d)\n"), pszSection, dwDisposition);
	return hSectionKey;
}
	

//-------------------------------------------------------------
//! @brief      int型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  nDefault エラー時に返す既定値
//! @return     値
//-------------------------------------------------------------
int CAppReg::GetProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nDefault )
{
	HKEY hSecKey = NULL;
	DWORD dwValue = 0;
	DWORD dwType = 0;
	DWORD dwCount = sizeof(DWORD);
	LONG lResult = 0;
	
	LOG(_T("> GetProfileInt( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return nDefault;
	}
	lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, (LPBYTE)&dwValue, &dwCount);
	if ( lResult != ERROR_SUCCESS || dwType != REG_DWORD ) {
		LOG(_T("RegQueryValueEx(%s) : lResult=0x%x, dwType=%d\n"), pszEntry, lResult, dwType);
		dwValue = (DWORD)nDefault;
	}
	
	::RegCloseKey(hSecKey);
	
	LOG(_T("< GetProfileInt() ret:%d\n"), (int)dwValue);
	return (int)dwValue;
}

//-------------------------------------------------------------
//! @brief      文字列型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszDefault エラー時に返す既定値
//! @return     値
//-------------------------------------------------------------
std::tstring CAppReg::GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault )
{
	HKEY hSecKey = NULL;
	LPTSTR pszValue = NULL;
	DWORD dwType = 0;
	DWORD dwCount = 0;
	LONG lResult = 0;
	std::tstring str(pszDefault);

	LOG(_T("> GetProfileString( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return str;
	}
	lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, NULL, &dwCount);
	if ( lResult != ERROR_SUCCESS || dwType != REG_SZ ) {
		LOG(_T("RegQueryValueEx(%s) : lResult=0x%x, dwType=%d\n"), pszEntry, lResult, dwType);
	}
	else {
		pszValue = (LPTSTR)malloc(dwCount * sizeof(TCHAR));
		if ( !pszValue ) {
			LOG(_T("cannot allocate enough memory.\n"));
		}
		else {
			pszValue[0] = _T('\0');
			lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, (LPBYTE)pszValue, &dwCount);
			if ( lResult != ERROR_SUCCESS ) {
				LOG(_T("RegQueryValueEx(%s) : 0x%x\n"), pszEntry, lResult);
			}
			str = pszValue;
			free(pszValue);
		}
	}
	::RegCloseKey(hSecKey);
	
	LOG(_T("< GetProfileString() ret:%s\n"), str.c_str());
	return str;
}

//-------------------------------------------------------------
//! @brief      文字列型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszDefault エラー時に返す既定値
//! @param[out] pszReturnedString 情報が格納されるバッファ
//! @param[in]  cchRetStr 情報バッファのサイズ
//! @return     バッファに格納された文字数を返す（終端\0を除く)
//-------------------------------------------------------------
DWORD CAppReg::GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault, LPTSTR pszReturnedString, DWORD cchRetStr )
{
	HKEY hSecKey = NULL;
	LPTSTR pszValue = NULL;
	DWORD dwType = 0;
	DWORD cbData = 0;
	LONG lResult = 0;
	BOOL bRet = FALSE;
	
	LOG(_T("> GetProfileString( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, NULL, &cbData);
	if ( lResult != ERROR_SUCCESS || dwType != REG_SZ ) {
		LOG(_T("RegQueryValueEx(%s) : lResult=0x%x, dwType=%d\n"), pszEntry, lResult, dwType);
		if ( pszDefault ) _tcsncpy_s(pszReturnedString, cchRetStr, pszDefault, cchRetStr - 1);
		else              pszReturnedString[0] = _T('\0');
	}
	else {
		pszValue = (LPTSTR)malloc(cbData);
		if ( !pszValue ) {
			LOG(_T("cannot allocate enough memory.\n"));
		}
		else {
			lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, (LPBYTE)pszValue, &cbData);
			if ( lResult != ERROR_SUCCESS ) {
				LOG(_T("RegQueryValueEx(%s) : 0x%x\n"), pszEntry, lResult);
			} else {
				_tcsncpy_s(pszReturnedString, cchRetStr, pszValue, _TRUNCATE);
				bRet = TRUE;
			}
			free(pszValue);
		}
	}
	::RegCloseKey(hSecKey);

	LOG(_T("< GetProfileString() ret:%s\n"), pszReturnedString);
	return _tcslen(pszReturnedString);
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[out] pData 情報が格納されるバッファ
//! @param[in,out] pBytes 情報バッファのサイズ
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppReg::GetProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD* pBytes )
{
	HKEY hSecKey = NULL;
	DWORD dwType = 0;
	LONG lResult = 0;
	
	LOG(_T("> GetProfileBinary( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, pData, pBytes);
	if ( lResult != ERROR_SUCCESS || dwType != REG_BINARY ) {
		LOG(_T("RegQueryValueEx(%s) : lResult=0x%x, dwType=%d\n"), pszEntry, lResult, dwType);
	}
	::RegCloseKey(hSecKey);

	LOG(_T("< GetProfileBinary() ret:%d\n"), (lResult == ERROR_SUCCESS));
	return (lResult == ERROR_SUCCESS);
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[out] ppData 情報が格納されるバッファ
//! @param[out] pBytes 情報バッファのサイズ
//! @return     TRUE on success, FALSE on failure.
//! @note       使用後はfree(*ppData)でメモリ解放すること
//-------------------------------------------------------------
BOOL CAppReg::GetProfileBinaryAlloc( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE* ppData, DWORD* pBytes )
{
	HKEY hSecKey = NULL;
	DWORD dwType = 0;
	LONG lResult = 0;
	
	LOG(_T("> GetProfileBinaryAlloc( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, NULL, pBytes);
	if ( lResult != ERROR_SUCCESS || dwType != REG_BINARY ) {
		LOG(_T("RegQueryValueEx(%s) : lResult=0x%x, dwType=%d\n"), pszEntry, lResult, dwType);
	}
	else {
		*ppData = (LPBYTE)malloc(*pBytes * sizeof(BYTE));
		if ( !(*ppData) ) {
			LOG(_T("cannot allocate enough memory.\n"));
		}
		else {
			lResult = ::RegQueryValueEx(hSecKey, pszEntry, NULL, &dwType, *ppData, pBytes);
			if ( lResult != ERROR_SUCCESS ) {
				LOG(_T("RegQueryValueEx(%s) : 0x%x\n"), pszEntry, lResult);
				free(*ppData);
				*ppData = NULL;
				*pBytes = 0;
			}
		}
	}
	::RegCloseKey(hSecKey);

	LOG(_T("< GetProfileBinaryAlloc() ret:%d\n"), (lResult == ERROR_SUCCESS));
	return (lResult == ERROR_SUCCESS);
}

//-------------------------------------------------------------
//! @brief      int型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  nValue 設定値
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppReg::WriteProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nValue )
{
	HKEY hSecKey = NULL;
	LONG lResult = 0;

	LOG(_T("> WriteProfileInt( %s, %s %d )\n"), pszSection, pszEntry, nValue);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegSetValueEx(hSecKey, pszEntry, NULL, REG_DWORD, (LPBYTE)&nValue, sizeof(nValue));
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegSetValueEx(%s) : 0x%x\n"), pszEntry, lResult);
	}

	::RegCloseKey(hSecKey);

	LOG(_T("< WriteProfileInt() ret:%d\n"), lResult);
	return (lResult == ERROR_SUCCESS);
}

//-------------------------------------------------------------
//! @brief      文字列型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszValue 設定値
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppReg::WriteProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszValue )
{
	HKEY hSecKey = NULL;
	LONG lResult = 0;

	LOG(_T("> WriteProfileString( %s, %s %s )\n"), pszSection, pszEntry, pszValue);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegSetValueEx(hSecKey, pszEntry, NULL, REG_SZ, (LPBYTE)pszValue, (_tcslen(pszValue)+1)*sizeof(TCHAR));
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegSetValueEx(%s) : 0x%x\n"), pszEntry, lResult);
	}

	::RegCloseKey(hSecKey);
	
	LOG(_T("< WriteProfileString() ret:%d\n"), lResult);
	return (lResult == ERROR_SUCCESS);
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pData 設定値
//! @param[in]  dwBytes 設定値のサイズ
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppReg::WriteProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD dwBytes )
{
	HKEY hSecKey = NULL;
	LONG lResult = 0;

	LOG(_T("> WriteProfileBinary( %s, %s )\n"), pszSection, pszEntry);
	
	hSecKey = GetSectionKey(pszSection);
	if ( !hSecKey ) {
		return FALSE;
	}
	lResult = ::RegSetValueEx(hSecKey, pszEntry, NULL, REG_BINARY, pData, dwBytes);
	if ( lResult != ERROR_SUCCESS ) {
		LOG(_T("RegSetValueEx(%s) : 0x%x\n"), pszEntry, lResult);
	}

	::RegCloseKey(hSecKey);
	
	LOG(_T("< WriteProfileBinary() ret:%d\n"), lResult);
	return (lResult == ERROR_SUCCESS);
}


//-------------------------------------------------------------
//! constructor
//-------------------------------------------------------------
CAppIni::CAppIni( LPCTSTR pszCompanyName, LPCTSTR pszAppName )
{
	TCHAR szPath[MAX_PATH];
	TCHAR drive[_MAX_DRIVE];
	TCHAR dir[_MAX_DIR];

	LOG(_T("> CAppIni( %s, %s )\n"), pszCompanyName, pszAppName);
	
	memset( m_szIniPath, 0, sizeof(m_szIniPath) );
	
	DWORD dwRet = ::GetModuleFileName( NULL, szPath, _countof(szPath) );
	if ( dwRet == 0 ) {
		LOG(_T("GetModuleFileName() : 0x%x\n"), dwRet);
		return;
	}

	_tsplitpath_s( szPath, drive, _countof(drive), dir, _countof(dir), NULL, 0, NULL, 0 );
	
	_tcscpy_s( m_szIniPath, _countof(m_szIniPath), drive );
	_tcscat_s( m_szIniPath, _countof(m_szIniPath), dir );
	_tcscat_s( m_szIniPath, _countof(m_szIniPath), pszAppName );
	_tcscat_s( m_szIniPath, _countof(m_szIniPath), _T(".ini") );

	LOG(_T("< CAppIni()\n"));
}

//-------------------------------------------------------------
//! destructor
//-------------------------------------------------------------
CAppIni::~CAppIni()
{
}

//-------------------------------------------------------------
//! @brief      int型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  nDefault エラー時に返す既定値
//! @return     値
//-------------------------------------------------------------
int CAppIni::GetProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nDefault )
{
	LOG(_T("> GetProfileInt( %s, %s )\n"), pszSection, pszEntry);
	
	int nVal = ::GetPrivateProfileInt( pszSection, 
									   pszEntry, 
									   nDefault, 
									   m_szIniPath );
	
	LOG(_T("< GetProfileInt() ret:%d\n"), nVal);
	return nVal;
}

//-------------------------------------------------------------
//! @brief      文字列型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszDefault エラー時に返す既定値
//! @return     値
//-------------------------------------------------------------
std::tstring CAppIni::GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault )
{
	TCHAR sz[1024];		//とりあえず
	
	LOG(_T("> GetProfileString( %s, %s )\n"), pszSection, pszEntry);
	
	DWORD dwRet = ::GetPrivateProfileString( pszSection, 
											 pszEntry, 
											 pszDefault, 
											 sz, 
											 _countof(sz), 
											 m_szIniPath );

	LOG(_T("< GetProfileString() ret:%s\n"), sz);
	return sz;
}

//-------------------------------------------------------------
//! @brief      文字列型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszDefault エラー時に返す既定値
//! @param[out] pszReturnedString 情報が格納されるバッファ
//! @param[in]  cchRetStr 情報バッファのサイズ
//! @return     バッファに格納された文字数を返す（終端\0を除く)
//-------------------------------------------------------------
DWORD CAppIni::GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault, LPTSTR pszReturnedString, DWORD cchRetStr )
{
	LOG(_T("> GetProfileString( %s, %s )\n"), pszSection, pszEntry);
	
	DWORD dwRet = ::GetPrivateProfileString( pszSection, 
											 pszEntry, 
											 pszDefault, 
											 pszReturnedString, 
											 cchRetStr, 
											 m_szIniPath );

	LOG(_T("< GetProfileString() ret:%s\n"), pszReturnedString);
	return dwRet;
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[out] pData 情報が格納されるバッファ
//! @param[in,out] pBytes 情報バッファのサイズ
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppIni::GetProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD* pBytes )
{
	LOG(_T("> GetProfileBinary( %s, %s )\n"), pszSection, pszEntry);
	
	BOOL bRet = ::GetPrivateProfileStruct( pszSection,
										   pszEntry,
										   pData,
										   *pBytes,
										   m_szIniPath );
										   
	LOG(_T("< GetProfileBinary() ret:%d\n"), bRet);
	return bRet;
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を取得する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[out] ppData 情報が格納されるバッファ
//! @param[out] pBytes 情報バッファのサイズ（1024固定）
//! @return     TRUE on success, FALSE on failure.
//! @note       使用後はfree(*ppData)でメモリ解放すること
//-------------------------------------------------------------
BOOL CAppIni::GetProfileBinaryAlloc( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE* ppData, DWORD* pBytes )
{
	LOG(_T("> GetProfileBinaryAlloc( %s, %s )\n"), pszSection, pszEntry);
	
	*pBytes = 1024;		// とりあえず
	
	*ppData = (LPBYTE)malloc(*pBytes * sizeof(BYTE));
	if ( !(*ppData) ) {
		LOG(_T("cannot allocate enough memory.\n"));
		return FALSE;
	}
	
	BOOL bRet = ::GetPrivateProfileStruct( pszSection,
										   pszEntry,
										   *ppData,
										   *pBytes,
										   m_szIniPath );
										   
	LOG(_T("< GetProfileBinaryAlloc() ret:%d\n"), bRet);
	return bRet;
}

//-------------------------------------------------------------
//! @brief      int型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  nValue 設定値
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppIni::WriteProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nValue )
{
	TCHAR sz[100];
	HKEY hSecKey = NULL;
	LONG lResult = 0;

	LOG(_T("> WriteProfileInt( %s, %s %d )\n"), pszSection, pszEntry, nValue);
	
	_stprintf_s( sz, _countof(sz), _T("%d"), nValue);
	BOOL bRet = ::WritePrivateProfileString( pszSection,
											 pszEntry,
											 sz,
											 m_szIniPath );

	LOG(_T("< WriteProfileInt() ret:%d\n"), bRet);
	return bRet;
}

//-------------------------------------------------------------
//! @brief      文字列型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  pszValue 設定値
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppIni::WriteProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszValue )
{
	LOG(_T("> WriteProfileString( %s, %s %s )\n"), pszSection, pszEntry, pszValue);
	
	BOOL bRet = ::WritePrivateProfileString( pszSection,
											 pszEntry,
											 pszValue,
											 m_szIniPath );
	
	LOG(_T("< WriteProfileString() ret:%d\n"), bRet);
	return bRet;
}

//-------------------------------------------------------------
//! @brief      バイナリ型の値を設定する
//! @param[in]  pszSection セクション名
//! @param[in]  pszEntry エントリ名
//! @param[in]  ppData 設定値
//! @param[in]  pBytes pDataのbyte数
//! @return     TRUE on success, FALSE on failure.
//-------------------------------------------------------------
BOOL CAppIni::WriteProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD dwBytes )
{
	LOG(_T("> WriteProfileBinary( %s, %s )\n"), pszSection, pszEntry);
	
	BOOL bRet = ::WritePrivateProfileStruct( pszSection,
											 pszEntry,
											 pData,
											 (UINT)dwBytes,
											 m_szIniPath );
	
	LOG(_T("< WriteProfileBinary() ret:%d\n"), bRet);
	return bRet;
}

