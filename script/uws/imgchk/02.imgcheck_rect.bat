@echo off

set BATCHDIR=%~dp0

set uwsc=C:\mywork\UWSC\UWSC.exe
call "%uwsc%" "%BATCHDIR%\02.imgcheck_rect.uws" "%1"

