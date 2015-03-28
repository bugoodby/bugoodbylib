@echo off

set BATCHDIR=%~dp0
set TTPMACRO=C:\Program Files (x86)\teraterm\ttpmacro.exe

"%TTPMACRO%" "%BATCHDIR%\01.command_line.ttl" "arg1" "arg2" "arg3" "arg4" 5


