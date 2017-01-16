@echo off
set BATCHDIR=%~dp0

for %%a in ( %* ) do (
	echo %%a
)

echo sub.bat start
timeout 5 /nobreak
echo sub.bat end

exit /b 5
