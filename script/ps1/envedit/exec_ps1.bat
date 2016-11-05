@echo off

set BATCHDIR=%~dp0

powershell -ExecutionPolicy RemoteSigned "%1"

pause
