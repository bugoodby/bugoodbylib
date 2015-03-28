@echo off

set BATCHDIR=%~dp0


echo caller : %cd%

echo caller : call start
call %BATCHDIR%\05.call_sub.bat
echo caller : call end

pause
