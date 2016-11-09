@echo off

set BATCHDIR=%~dp0

rem powershell -ExecutionPolicy RemoteSigned -STA -WindowStyle Hidden "%BATCHDIR%\startprocess.ps1"
powershell -ExecutionPolicy RemoteSigned -STA "%BATCHDIR%\startprocess.ps1"

pause