/*! 
 * @file    strpool.h
 * @brief   文字列バッファ
 *
 * @author  
 */
#ifndef _STRPOOL_H_
#define _STRPOOL_H_

////////////////////////////////////////////////////////////////////////////////////
//
// CStrPool
// 文字列バッファ
//
////////////////////////////////////////////////////////////////////////////////////
class CStrPool
{
public:
	CStrPool( size_t maxsize = 65536, size_t blocksize = 1024 );
	virtual ~CStrPool(void);
	
	void Empty();
	
	BOOL FormatVW( LPCWSTR format, va_list argp );
	BOOL FormatVA( LPCSTR format, va_list argp );
	BOOL AppendFormatVW( LPCWSTR format, va_list argp );
	BOOL AppendFormatVA( LPCSTR format, va_list argp );
	
	BOOL AppendW( LPCWSTR pszText );
	BOOL AppendA( LPCSTR pszText );
	BOOL AppendFormatW( LPCWSTR format, ... );
	BOOL AppendFormatA( LPCSTR format, ... );

	//-------------------------------------------------------------
	//! @brief      +=演算子にAppend()を割り当て
	//-------------------------------------------------------------
	BOOL operator+=( LPCWSTR pszText ) { return AppendW(pszText); }
	BOOL operator+=( LPCSTR pszText ) { return AppendA(pszText); }

	//-------------------------------------------------------------
	//! @brief      バッファへのポインタを直接取得する
	//! @return     バッファへのポインタ
	//-------------------------------------------------------------
	inline LPCWSTR GetBuffer() { return m_psz; }

	//-------------------------------------------------------------
	//! @brief      バッファに書かれた文字列のサイズを取得する
	//! @return     文字列のサイズ(TCHAR単位)
	//-------------------------------------------------------------
	inline size_t GetLength() { return m_len; }

protected:
	LPWSTR		m_psz;			//!< バッファ
	size_t		m_len;			//!< バッファに書かれた文字列のサイズ (WCHAR単位)
	size_t		m_size;			//!< バッファのサイズ (WCHAR単位)
	
	size_t		m_blocksize;	//!< メモリ確保単位 (WCHAR単位)
	size_t		m_maxsize;		//!< メモリ確保の上限 (WCHAR単位)

	BOOL x_reallocMemory( size_t size );
	BOOL x_reallocEnoughMemory( size_t string_len );
	LPWSTR x_convertToUnicode( LPCSTR pszText );
};


#endif /* _STRPOOL_H_ */

