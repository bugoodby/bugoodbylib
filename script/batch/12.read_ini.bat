@echo off

set BATCHDIR=%~dp0
set SETTINGFILE=%BATCHDIR%\12.read_ini.ini

for /F "eol=; delims== tokens=1,2" %%x in (%SETTINGFILE%) do (
    set KEY=%%x
    if not "!KEY:~0,1!"=="#" (
        set %%x=%%y
    )
)

echo boolean: %boolean%
echo string: %string%
echo comment: %comment%
pause
