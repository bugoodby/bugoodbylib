@echo off

set COUNT=0
for %%a in ( %* ) do set /a COUNT+=1

echo count:%COUNT%

for %%a in ( %* ) do (
	echo %%a
)

pause
