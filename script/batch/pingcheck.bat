@echo off
rem -------------------------------------------------------
rem  �����Ŏw�肳�ꂽIP�A�h���X�ɑ΂���ping�����s
rem  TTL=�̍s�������ping�����Ɣ��f����OK��\������
rem -------------------------------------------------------

if "%~1"=="" (
	echo IP�A�h���X���w�肵�Ă�������
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


