@echo off
rem -------------------------------------------------------
rem  引数で指定されたIPアドレスに対してpingを実行
rem  TTL=の行があればping成功と判断してOKを表示する
rem -------------------------------------------------------

if "%~1"=="" (
	echo IPアドレスを指定してください
	exit /b 0
)

set BATCHDIR=%~dp0
set TMPFILE=%BATCHDIR%\tmp_ping_result.txt

echo ping to %1 ...

ping %1 > %TMPFILE%
findstr "TTL=" %TMPFILE%
if %ERRORLEVEL% EQU 0 (
	echo.   OK
) else (
	echo.   NG
)


