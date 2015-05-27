@echo off

set BATCHDIR=%~dp0

set uwsc=C:\mywork\UWSC\UWSC.exe
"%uwsc%" "%BATCHDIR%\01.command_line.uws" "hoge" "piyo"

