@echo off
rem -------------------------------------------------------
rem  - testフォルダを空にする
rem  - 引数で指定されたコマンドをそれぞれ実行する
rem -------------------------------------------------------

set BATCHDIR=%~dp0
set RESULTDIR=%BATCHDIR%test

echo Clean up folder...
if exist "%RESULTDIR%" (
	rmdir /S /Q "%RESULTDIR%"
)
mkdir "%RESULTDIR%"

for %%a in (%*) do (
	echo EXEC: %%~na
rem 	"%%a"
	timeout 3 /nobreak
)


pause
