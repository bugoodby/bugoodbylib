@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo �t�@�C�����w�肵�Ă�������
	pause
	exit 0
)

set script=%BATCHDIR%\dumpbin.py
"C:\Program Files (x86)\IronPython 2.7\ipy.exe" "%script%" "%1"

pause
