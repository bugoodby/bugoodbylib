@echo off

set BATCHDIR=%~dp0

call powershell -ExecutionPolicy RemoteSigned -STA -WindowStyle Hidden "%BATCHDIR%\startprocess.ps1"

