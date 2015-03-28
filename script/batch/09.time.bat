@echo off

set BATCHDIR=%~dp0

set DATESTR=%DATE:/=%
set TIMESTR=%TIME:/ =0%
set TIMESTR2=%TIMESTR:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%

echo %DATESTR%
echo %TIMESTR%
echo %TIMESTR2%

echo hogehoge_%DATESTR%_%TIMESTR2%.log

pause
