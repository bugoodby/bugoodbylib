@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo �t�@�C�����w�肵�Ă�������
	pause
	exit 0
)

set uwsc=D:\mydoc\Documents\app\UWSC\uwsc501\UWSC.exe
"%uwsc%" "%1"

