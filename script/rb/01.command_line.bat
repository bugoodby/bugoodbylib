@echo off
set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit 0
)

set SCRIPT=%BATCHDIR%01.command_line.rb
ruby "%SCRIPT%" %*

pause
