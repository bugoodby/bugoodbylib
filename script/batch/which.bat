@echo off
rem -------------------------------------------------------
rem  which�����̓���������o�b�`�����A
rem  windows�ł�where���g���΂悢
rem -------------------------------------------------------

if "%~1"=="" (
	echo usage: which command name
	exit /b 0
)

for %%I in (%1 %1.exe %1.bat %1.cmd %1.com %1.vbs %1.js %1.wsf) do (
	if exist %%~$path:I echo %%~$path:I
)
