@echo off

set BATCHDIR=%~dp0

set uwsc=C:\mywork\UWSC\UWSC.exe
call "%uwsc%" "%BATCHDIR%\01.imgchk.uws" "%1"

