@echo off
set PS_SCRIPT=%~dp0\dumpbin.ps1
powershell -ExecutionPolicy RemoteSigned "%PS_SCRIPT%" "%1"

pause
