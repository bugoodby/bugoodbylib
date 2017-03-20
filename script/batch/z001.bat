@echo off
set BATCHDIR=%~dp0

rem ##############################
where notepad | findstr /N "C:\Windows\notepad"
if not "%ERRORLEVEL%" == "0" (
	color CF
	echo [ERROR] command not found
	goto EXIT
)
echo ### TEST1 OK ###



rem ##############################
where notepad > __tmp.txt
for /F %%A IN (__tmp.txt) do (
	echo %%A > __tmp.txt
	goto break
)
:break
findstr /N "C:\Windows\notepad" __tmp.txt
if not "%ERRORLEVEL%" == "0" (
	color CF
	echo [ERROR] command not found
	goto EXIT
)
echo ### TEST2 OK ###



rem ##############################
findstr "BATCHDIR" "%BATCHDIR%\z001.bat"
if not "%ERRORLEVEL%" == "0" (
	color CF
	echo [ERROR] string not found
	goto EXIT
)
echo ### TEST3 OK ###



:EXIT
pause
