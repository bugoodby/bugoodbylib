@echo off

set BATCHDIR=%~dp0

rem Windows7 or later
echo timeout start.
timeout 5 /nobreak
echo timeout end.

rem use ping
echo ping start.
ping 127.0.0.1 -n 5 > nul
echo ping start.

pause
