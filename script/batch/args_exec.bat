@echo off
rem -------------------------------------------------------
rem  - test�t�H���_����ɂ���
rem  - �����Ŏw�肳�ꂽ�R�}���h�����ꂼ����s����
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
