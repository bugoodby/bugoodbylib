@echo off
set PS_SCRIPT=%~dp0\01.command_line.ps1
powershell -ExecutionPolicy RemoteSigned -STA -File "%PS_SCRIPT%" %*
pause
