@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

set script=%BATCHDIR%\dumpbin.py
"C:\Program Files (x86)\IronPython 2.7\ipy.exe" "%script%" "%1"

pause
