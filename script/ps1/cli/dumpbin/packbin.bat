@echo off
set PS_SCRIPT=%~dp0\packbin.ps1
powershell -ExecutionPolicy RemoteSigned -STA -File "%PS_SCRIPT%" %*

pause
