@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo �t�@�C�����w�肵�Ă�������
	pause
	exit 0
)

set script=%BATCHDIR%\packbin.rb
ruby -Ku "%script%" "%1"

pause
