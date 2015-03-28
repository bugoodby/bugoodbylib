/*! 
 * @file    strpool.h
 * @brief   ������o�b�t�@
 *
 * @author  
 */
#ifndef _STRPOOL_H_
#define _STRPOOL_H_

////////////////////////////////////////////////////////////////////////////////////
//
// CStrPool
// ������o�b�t�@
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
	//! @brief      +=���Z�q��Append()�����蓖��
	//-------------------------------------------------------------
	BOOL operator+=( LPCWSTR pszText ) { return AppendW(pszText); }
	BOOL operator+=( LPCSTR pszText ) { return AppendA(pszText); }

	//-------------------------------------------------------------
	//! @brief      �o�b�t�@�ւ̃|�C���^�𒼐ڎ擾����
	//! @return     �o�b�t�@�ւ̃|�C���^
	//-------------------------------------------------------------
	inline LPCWSTR GetBuffer() { return m_psz; }

	//-------------------------------------------------------------
	//! @brief      �o�b�t�@�ɏ����ꂽ������̃T�C�Y���擾����
	//! @return     ������̃T�C�Y(TCHAR�P��)
	//-------------------------------------------------------------
	inline size_t GetLength() { return m_len; }

protected:
	LPWSTR		m_psz;			//!< �o�b�t�@
	size_t		m_len;			//!< �o�b�t�@�ɏ����ꂽ������̃T�C�Y (WCHAR�P��)
	size_t		m_size;			//!< �o�b�t�@�̃T�C�Y (WCHAR�P��)
	
	size_t		m_blocksize;	//!< �������m�ےP�� (WCHAR�P��)
	size_t		m_maxsize;		//!< �������m�ۂ̏�� (WCHAR�P��)

	BOOL x_reallocMemory( size_t size );
	BOOL x_reallocEnoughMemory( size_t string_len );
	LPWSTR x_convertToUnicode( LPCSTR pszText );
};


#endif /* _STRPOOL_H_ */

