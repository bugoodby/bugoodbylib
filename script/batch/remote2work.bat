@echo off
set BATCHDIR=%~dp0

echo [before] %cd%

pushd "%LOCALAPPDATA%"

set WORKDIR=%cd%\bugoodby\batch
if not exist "%WORKDIR%" (
	mkdir "%WORKDIR%"
)
cd "%WORKDIR%"

echo [after] %cd%
explorer "%WORKDIR%"

pause

