@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

set uwsc=C:\mywork\UWSC\UWSC.exe
"%uwsc%" "%1"


