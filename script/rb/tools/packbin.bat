@echo off

set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

set script=%BATCHDIR%\packbin.rb
ruby -Ku "%script%" "%1"

pause
