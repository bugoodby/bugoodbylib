@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

set uwsc=D:\mydoc\Documents\app\UWSC\uwsc501\UWSC.exe
"%uwsc%" "%1"

