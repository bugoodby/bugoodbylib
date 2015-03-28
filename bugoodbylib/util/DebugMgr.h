/*! 
 * @file    DebugMgr.h
 * @brief   Debugging Utilities
 *
 * @author  
 */
#ifndef _DEBUGMGR_H_
#define _DEBUGMGR_H_

#define LOG dbgLoggingW
#define LOGA dbgLoggingA

void dbgInitialize();
void dbgTerminate();

void dbgLoggingW( const wchar_t *format, ... );
void dbgLoggingA( const char *format, ... );

void dbgDumpW( const void *pData, size_t size );
void dbgDumpA( const void *pData, size_t size );


#endif/* _DEBUGMGR_H_ */
