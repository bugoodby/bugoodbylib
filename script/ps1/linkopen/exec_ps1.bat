@echo off

set BATCHDIR=%~dp0

powershell -ExecutionPolicy RemoteSigned -STA "%1"

pause
