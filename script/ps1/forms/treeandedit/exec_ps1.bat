@echo off

set BATCHDIR=%~dp0
set SCRIPTNAME=treeandedit.ps1

rem powershell -ExecutionPolicy RemoteSigned -STA -WindowStyle Hidden "%BATCHDIR%%SCRIPTNAME%"
powershell -ExecutionPolicy RemoteSigned -STA "%BATCHDIR%%SCRIPTNAME%"

pause
