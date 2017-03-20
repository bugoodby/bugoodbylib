@echo off
set PS_SCRIPT=%~dp0\envedit.ps1
rem powershell -ExecutionPolicy RemoteSigned -STA -WindowStyle Hidden -Verb Runas -File "%PS_SCRIPT%" %* 
powershell -ExecutionPolicy RemoteSigned -STA -File "%PS_SCRIPT%" %* 
