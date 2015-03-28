/*! 
 * @file    SettingMgr.h
 * @brief   設定値の管理 (class CAppReg, CAppIni)
 *
 * @author  
 */
#ifndef _SETTINGMGR_H_
#define _SETTINGMGR_H_

#include <string>

namespace std
{
typedef std::basic_string< TCHAR, std::char_traits<TCHAR>,
	std::allocator<TCHAR> > tstring;
} /* namespace std */


///////////////////////////////////////////////////////////////
//
//  CAppReg
//! @brief レジストリでの設定値マネージャ
//
///////////////////////////////////////////////////////////////
class CAppReg
{
private:
	HKEY		m_hSoftware;
	HKEY		m_hCompany;
	HKEY		m_hApplication;

public:
	CAppReg( LPCTSTR pszCompanyName, LPCTSTR pszAppName );
	virtual ~CAppReg();

	HKEY			GetSectionKey( LPCTSTR pszSection );
	
	int				GetProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nDefault );
	std::tstring	GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault );
	DWORD			GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault, LPTSTR pszReturnedString, DWORD cchRetStr );
	BOOL			GetProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD* pBytes );
	BOOL			GetProfileBinaryAlloc( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE* ppData, DWORD* pBytes );
	BOOL			WriteProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nValue );
	BOOL			WriteProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszValue );
	BOOL			WriteProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD dwBytes );
};


///////////////////////////////////////////////////////////////
//
//  CAppIni
//! @brief INIファイルでの設定値マネージャ
//
///////////////////////////////////////////////////////////////
class CAppIni
{
private:
	TCHAR		m_szIniPath[MAX_PATH];
	
public:
	CAppIni( LPCTSTR pszCompanyName, LPCTSTR pszAppName );
	virtual ~CAppIni();
	
	int				GetProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nDefault );
	std::tstring	GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault );
	DWORD			GetProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszDefault, LPTSTR pszReturnedString, DWORD cchRetStr );
	BOOL			GetProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD* pBytes );
	BOOL			GetProfileBinaryAlloc( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE* ppData, DWORD* pBytes );
	BOOL			WriteProfileInt( LPCTSTR pszSection, LPCTSTR pszEntry, int nValue );
	BOOL			WriteProfileString( LPCTSTR pszSection, LPCTSTR pszEntry, LPCTSTR pszValue );
	BOOL			WriteProfileBinary( LPCTSTR pszSection, LPCTSTR pszEntry, LPBYTE pData, DWORD dwBytes );
};



#endif /* _SETTINGMGR_H_ */
