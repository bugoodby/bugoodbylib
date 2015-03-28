@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

echo =====================
echo original    : %1
echo delete ""   : %~1
echo full        : %~f1
echo drive       : %~d1
echo folder      : %~p1
echo drive+folder: %~dp1
echo file        : %~n1
echo extension   : %~x1
echo file+ext    : %~nx1
echo =====================

set script=%BATCHDIR%02.path.rb
ruby -Ku "%script%" "%1" > %~dp1kekka.txt

pause
