@echo off

set BATCHDIR=%~dp0

rem -------------------------------
rem �m�F
rem -------------------------------
set /p ANSWER="���s���܂��B��낵���ł����H(y/n): "
if not "%ANSWER%"=="y" (
	exit 0
)

rem -------------------------------
rem ���[�U���E�p�X���[�h����
rem -------------------------------
set /p USER="USER: "
set /p PASS="PASS: "

echo -------------
echo USER=%USER%
echo PASS=%PASS%


pause
