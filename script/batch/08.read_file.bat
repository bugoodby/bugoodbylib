@echo off

set BATCHDIR=%~dp0

for /f "delims=" %%l in (%BATCHDIR%\01.command_line.bat) do (
    echo %%l
)

pause
