@echo off

set BATCHDIR=%~dp0
pushd %BATCHDIR%

echo ----------------------------------------
echo [0] getInputString1
echo [1] getInputString2
echo [2] getInputString3
echo [q] quit
echo ----------------------------------------
set /P USR_INPUT_STR=": "

echo %USR_INPUT_STR%

if "%USR_INPUT_STR%"=="0" (
	echo Selected 0
) else if "%USR_INPUT_STR%"=="1" (
	echo Selected 1
) else if "%USR_INPUT_STR%"=="2" (
	echo Selected 2
) else (
	echo quit
)

popd
pause
