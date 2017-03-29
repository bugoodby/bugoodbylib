@echo off
set BATCHDIR=%~dp0
set SCRIPTNAME=z001.ps1
powershell -ExecutionPolicy RemoteSigned -STA -File "%BATCHDIR%\%SCRIPTNAME%" %*

pause