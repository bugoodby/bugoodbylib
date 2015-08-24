@echo off

set BATCHDIR=%~dp0

rem -------------------------------
rem 確認
rem -------------------------------
set /p ANSWER="続行します。よろしいですか？(y/n): "
if not "%ANSWER%"=="y" (
	exit 0
)

rem -------------------------------
rem ユーザ名・パスワード入力
rem -------------------------------
set /p USER="USER: "
set /p PASS="PASS: "

echo -------------
echo USER=%USER%
echo PASS=%PASS%


pause
