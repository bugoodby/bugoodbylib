@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo �t�@�C�����w�肵�Ă�������
	pause
	exit 0
)

set script=%BATCHDIR%\dumpbin2.rb
ruby -Ku "%script%" "%1"
ruby -Ku "%script%" "%1" > output.txt

pause
