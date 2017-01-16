@echo off

set BATCHDIR=%~dp0
set SCRIPT=%BATCHDIR%sub.ps1

echo --------------
powershell -ExecutionPolicy RemoteSigned -File "%SCRIPT%"
echo --------------

echo ExitCode: %ERRORLEVEL%

pause

