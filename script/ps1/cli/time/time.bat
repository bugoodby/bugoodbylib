@echo off
set BATCHDIR=%~dp0
set SCRIPTNAME=time.ps1
powershell -ExecutionPolicy RemoteSigned -STA -File "%BATCHDIR%\%SCRIPTNAME%" "%1"

pause