@echo off
set BATCHDIR=%~dp0

powershell -ExecutionPolicy RemoteSigned -File "%1"

pause
