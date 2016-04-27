@echo off
set BATCHDIR=%~dp0

if "%1"=="" (
	echo ファイルを指定してください
	pause
	exit /b 0
)

echo =====================
echo %%0          : %0
echo batch full  : %~f0
echo batch dir   : %~dp0
echo other file  : %~dp0hoge.txt

set BATCHDIR=%~dp0
echo remove \    : %BATCHDIR:~0,-1%

echo =====================
echo %%cd%%        : %cd%
rem %~d0 && cd %~dp0
pushd %~dp0
echo %%cd%% (after): %cd%
popd

echo =====================
echo original    : %1
echo delete ""   : %~1
echo full        : %~f1
echo drive       : %~d1
echo folder      : %~p1
echo drive+folder: %~dp1
echo file        : %~n1
echo extension   : %~x1
echo file+ext    : %~nx1


pause
